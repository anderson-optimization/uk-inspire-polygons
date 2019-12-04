import requests
import urllib.request
import time
from bs4 import BeautifulSoup
from ratelimit import limits, sleep_and_retry

import boto3

# Period is in seconds
@sleep_and_retry
@limits(calls=1, period=2)
def download_report(link=None,key=None,ctype=None,archive_bucket=None):
	print('Get report {}'.format(key))
	r = requests.get(link)
	print('Request finished')
	content_type=None
	print('headers',r.headers)
	if 'Content-Type' in r.headers:
		content_type=r.headers['Content-Type']
	elif ctype=='zip':
		content_type = 'application/zip'
	elif ctype=='xlsx':
		content_type = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
	elif not ctype:
		raise Exception('No content type given')
	else:
		raise Exception('type not understood {}'.format(ctype))

	if not content_type:
		raise Exception('no content type')

	if 'Content-Disposition' in r.headers:
		archive_bucket.put_object(Key=key,Body=r.content,ContentType=content_type,ContentDisposition=r.headers['Content-Disposition'])
	else:
		archive_bucket.put_object(Key=key,Body=r.content,ContentType=content_type)

	print('Report synced to s3')


base_url="https://www.gov.uk"
collection_url="{}/government/collections/download-inspire-index-polygons".format(base_url)

response = requests.get(collection_url)
soup = BeautifulSoup(response.text, "html.parser")


archive_bucket_name="bucket"

s3 = boto3.resource('s3')
archive_bucket = s3.Bucket(archive_bucket_name)


links=[t for t in soup.findAll('a',href=True)]
inspire_links=[link for link in links if 'INSPIRE' in link.text]

doc_links=[]
visited=0
for link in inspire_links:
	visited+=1
	print(link.text,link['href'])

	page_url="{}{}".format(base_url,link['href'])

	page_response = requests.get(page_url)
	page_soup = BeautifulSoup(page_response.text, "html.parser")

	page_links=[t for t in page_soup.findAll('a',href=True)]
	page_link=[t for t in page_links if 'INSPIRE' in t.text]

	for link in page_link:
		link_url = link['href']

		if link_url.split('.')[-1] == 'zip':
			doc_links.append(link_url)
			print('Found link {}'.format(link_url))
			link_key="files/{}".format(link_url.split('/')[-1])
			download_report(link=link_url,key=link_key,archive_bucket=archive_bucket)
	print('Found {} links from {}/{} pages'.format(len(doc_links),visited,len(inspire_links)))