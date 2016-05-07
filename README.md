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

#### POST

Convert a markdown file to the specfied format (with a template if needed)

- arguments

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object|The markdown file (multipart/form-data)|
|output_type|true|string|The format name. Valid format names are gotten by the API 'GET /types'|
|template|false|string|The name of a registered template file. Valid names are gotten by the API 'GET /templates/lists'|

- normal respons

```text
$ curl -i -F "file=@./README.md" -F "output_type=html" -F "template=sample.css" http://$address/convert
HTTP/1.1 200 OK
Content-Type: text/html;charset=utf-8

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="generator" content="pandoc">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
  <title></title>
  ...
  ...
```

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
|type|true|string|The format name. (Ex. html, word)|
|name|true|string|The name of a registered template file.|

Example:

```text
$ curl -i "http://$address/templates?type=html&name=sample.css"
HTTP/1.1 200 OK
Content-Type: text/css;charset=utf-8

h1 {
    text-decoration: underline;
}

table {
    border: 2px double black;
    border-collapse: collapse;
}
...
...
```

#### POST

Post a new template file.

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file object|The template file (multipart/form-data)|
|type|true|string|The format name. (Ex. html, word)|
|name|true|string|The name for register.|

- normal status

```text
$ curl -i -F "file=@./temp.css" -F "type=html" -F "name=some_name.css" http://$address/templates
HTTP/1.1 200 OK
Content-Type: application/json

{"type":"html","name":"some_name.css"}
```

- error status

If the name is already registered in the type, the error status 400 is returned.


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
