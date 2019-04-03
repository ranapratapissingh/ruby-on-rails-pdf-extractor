
# PDF Extractor

This tool helps you to liberate data tables trapped inside PDF files.

Extremely useful tool for Data Scientist, Data Analyst and BI Analyst.

## Why PDF Extractor?

If you’ve ever tried to do anything with data provided to you in PDFs, you
know how painful this is — you can’t easily copy-and-paste rows of data out
of PDF files. **PDF Extractor** allows you to extract that data in [CSV,JSON,TSV,ZIP] format, through
a simple web interface.

## Using PDF Extractor

First, make sure you have a recent copy of Java installed. PDF Extractor requires
a Java Runtime Environment compatible with Java 7 (i.e. Java 7, 8 or higher).


## Running PDF Extractor from source (for developers)

1. Install `ruby`. 
    ~~~
      cd ~
      rbenv install -v 2.3.1
      rbenv global 2.3.1
      rbenv versions
      ruby -v
    ~~~

2. Install `java 7`(i.e. Java 7, 8 or higher).

3. Install JRuby(JavaRuby). You can install it from its website, or using tools like
   `rvm` or `rbenv`. PDF Extractor uses the JRuby 9000 series (i.e. JRuby 9.1.5.0).
    ~~~
      rbenv install jruby-9.2.0.0
    ~~~

4. Now install the Ruby dependencies. (Note: if using `rvm` or
   `rbenv`, ensure that JRuby is being used.

    a). First download or clone this repository, then go to the folder `pdf-extractor`
    ~~~
    https://github.com/vickymax/pdf-extractor.git
    cd pdf-extractor

    gem install bundler -v 1.5.0
    bundle install
    jruby -S jbundle install
    jbundle update
    jbundle show(optional command)
    ~~~

**Then, start the development server by running below command:**

    RACK_ENV=development jruby -G -r jbundler -S rackup -p 9000
  
    RACK_ENV=development jruby -G -r jbundler -S rackup -o 127.0.0.1  -p 9000


**To run in production mode:** 

    RACK_ENV=production jruby -G -r jbundler -S rackup -p 9000

    RACK_ENV=production jruby -G -r jbundler -S -o 127.0.0.1 rackup -p 9000

**After server start, you will see all details on console:**
~~~
ROOT_DIR = /home/yourusername/Projects/pdf-extractor
DATA_DIR = /home/yourusername/Projects/pdf-extractor/webapp/upload
DOCUMENTS_BASEPATH = /home/yourusername/Projects/pdf-extractor/webapp/upload/pdfs
ENABLE_DEBUG_METHODS = true
DOCUMENTS_RELATIVEPATH = webapp/upload/pdfs
DOCUMENTS_OUTPUTPATH = webapp/static/export
MONGO ENDPOINT = 127.0.0.1:27017
running under / as root URI
Puma starting in single mode...
 Version 3.12.0 (jruby 9.2.0.0 - ruby 2.5.0), codename: Llamas in Pajamas
 Min threads: 0, max threads: 16
 Environment: development
 Listening on tcp://127.0.0.1:9000
Use Ctrl-C to stop
~~~

For backend, I have done configuration of mongodb, you just need to do little tweak in `settings.rb` as per your system informations.

The site instance should now be viewable at http://127.0.0.1:9000/

**Sample file to upload and test the feature is in the parent directory.**

    kotak.pdf

## Still look wrong? 

Contact the developer and tell me what you tried to do that didn’t work.

- [Reporting an issue](https://github.com/vickymax/pdf-extractor/issues/new).

    