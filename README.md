# Web-Md-Converter

[![Circle CI](https://circleci.com/gh/eshamster/web_md_converter.svg?style=svg)](https://circleci.com/gh/eshamster/web_md_converter)

Web-Md-Converter is a markdown files converter using pandoc. This includes the manager templates.

## Version information

- Tested on ruby 2.1.0, 2.2.0, 2.3.0
- Using pandoc 1.17.0.3 in our development environment

## API

### /convert

Convert a markdown file to another file by specfied format

#### POST

- arguments

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|file||
|output_type|true|string||
|template|false|string|The name of a registered template file|

- normal respons

- error responses

### /templates

Manage template files for various formats

#### GET

#### POST

## License

Licensed under the MIT License.
