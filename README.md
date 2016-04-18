# Web-Md-Converter

[![Circle CI](https://circleci.com/gh/eshamster/web_md_converter.svg?style=svg)](https://circleci.com/gh/eshamster/web_md_converter)

## Memo

- This is tested on ruby 2.1.0, 2.2.0, 2.3.0

## API

### /convert

Convert a markdown file to another file by specfied format

#### POST

- arguments

|Name|Required?|Type|Description|
|:---|:---|:---|:---|
|file|true|||
|output_type|true|string||
|template|false|string|The name of a registered template file|

- normal respons

- error responses

## License

Licensed under the MIT License.
