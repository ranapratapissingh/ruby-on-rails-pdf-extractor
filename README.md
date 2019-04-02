
# XML Extractor

Tabula helps you liberate data tables trapped inside PDF files.

## Why XML Extractor?

If you’ve ever tried to do anything with data provided to you in PDFs, you
know how painful this is — you can’t easily copy-and-paste rows of data out
of PDF files. **XML Extractor** allows you to extract that data in CSV format, through
a simple web interface.

## Using XML Extractor

First, make sure you have a recent copy of Java installed. You can
[download Java here][jre_download]. Tabula requires
a Java Runtime Environment compatible with Java 7 (i.e. Java 7, 8 or higher).


## Running Tabula from source (for developers)

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
   `rvm` or `rbenv`. XML Extractor uses the JRuby 9000 series (i.e. JRuby 9.1.5.0).
    ~~~
      rbenv install jruby-9.2.0.0
    ~~~

4. Now install the Ruby dependencies. (Note: if using `rvm` or
   `rbenv`, ensure that JRuby is being used.

    a). First download or clone this repository, then go to folder like `xml-extractor`
    ~~~
    https://github.com/vickymax/xml-extractor.git
    cd xml-extractor

    gem install bundler -v 1.5.0
    bundle install
    jruby -S jbundle install
    jbundle update
    jbundle show(optional command)
    ~~~

**Then, start the development server by running below command:**

    RACK_ENV=development jruby -G -r jbundler -S rackup -p 9000

**To run in production mode:** 

    RACK_ENV=production jruby -G -r jbundler -S rackup -p 9000

MongoDB setup is configured in this project, you just have to install mongodb into your local system. You just have to do little tweak in settings.rb file.

(If you get encoding errors, set the `JAVA_OPTS` environment variable to `-Dfile.encoding=utf-8`)

The site instance should now be viewable at http://127.0.0.1:9000/ .