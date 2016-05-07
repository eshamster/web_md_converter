# Web-Md-Converter

[![Circle CI](https://circleci.com/gh/eshamster/web_md_converter.svg?style=svg)](https://circleci.com/gh/eshamster/web_md_converter)

Web-Md-Converter is a markdown files converter using pandoc. This includes the templates manager.

## Version information

- Tested on ruby 2.1.0, 2.2.0, 2.3.0
- Using pandoc 1.17.0.3 in our development environment

## Web Interface

TODO: Not documented

## API

### /convert

Convert a markdown file to another file by specfied format

#### POST

- arguments

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object||
|output_type|true|string||
|template|false|string|The name of a registered template file|

- normal respons

- error responses

### /templates/lists

#### GET

Get lists of templates. Keys and values of the return value by this API are used in other APIs.

- A key: 'output_type' or 'type'
- An element of the values (= array): 'template' or 'name'

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|-|-|-|-|

***Notes: There are no arguments***

Example:

```text
$ curl -i http://$address/templates/lists
HTTP/1.1 200 OK 
Content-Type: application/json

{
  "word": ["test2.dotx", "test1.dotx"],
  "html": ["test3.css", "test2.css", "test1.css"]
}
```

### /templates

Manage template files for various formats

#### GET

Get a template file

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|type|true|string||
|name|true|string||

#### POST

Post a new template file

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object||
|type|true|string||
|name|true|string||

#### DELETE

Delete a template file

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|type|true|string||
|name|true|string||

### /types

#### GET

Get information of all supported types

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|-|-|-|-|

***Notes: There are no arguments***

Example:

```text
HTTP/1.1 200 OK
Content-Type: application/json

{
  "html": {
    "content_type": "text/html",
    "specifier": "html",
    "template_content_type": "text/css"
  },
  "word": {
    "content_type": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "specifier": "docx",
    "template_content_type": "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
  }
}
```

## License

Licensed under the MIT License.
