# RubyLexer
## Installation and Running guide
1. git clone this repo to your local machine
2. cd src
3. javac RubyLexer.java to compiler the .java file
4. java RubyLexer input.rb

## How it works?
1. To produce a lexical analyser, we first need to declare our .jflex file
2. In .jflex file, we declare the grammar and different state rules for every possible input.
3. We return every matches as token and catches invalid input as error