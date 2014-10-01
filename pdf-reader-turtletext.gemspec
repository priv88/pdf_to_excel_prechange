--- !ruby/object:Gem::Specification
name: pdf-reader-turtletext
version: !ruby/object:Gem::Version
  version: 0.2.2
platform: ruby
authors:
- Paul Gallagher
autorequire: 
bindir: bin
cert_chain: []
date: 2012-08-01 00:00:00.000000000 Z
dependencies:
- !ruby/object:Gem::Dependency
  name: pdf-reader
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - '='
      - !ruby/object:Gem::Version
        version: 1.1.1
  type: :runtime
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - '='
      - !ruby/object:Gem::Version
        version: 1.1.1
- !ruby/object:Gem::Dependency
  name: bundler
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.1.4
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.1.4
- !ruby/object:Gem::Dependency
  name: jeweler
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.6.4
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.6.4
- !ruby/object:Gem::Dependency
  name: rake
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 0.9.2.2
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 0.9.2.2
- !ruby/object:Gem::Dependency
  name: rspec
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 2.8.0
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 2.8.0
- !ruby/object:Gem::Dependency
  name: rdoc
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: '3.11'
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: '3.11'
- !ruby/object:Gem::Dependency
  name: prawn
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 0.12.0
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 0.12.0
- !ruby/object:Gem::Dependency
  name: guard-rspec
  requirement: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.2.0
  type: :development
  prerelease: false
  version_requirements: !ruby/object:Gem::Requirement
    requirements:
    - - ~>
      - !ruby/object:Gem::Version
        version: 1.2.0
description: a library that can read structured and positional text from PDFs. Ideal
  for asembling structured data from invoices and the like.
email: gallagher.paul@gmail.com
executables: []
extensions: []
extra_rdoc_files:
- LICENSE
- README.rdoc
files:
- LICENSE
- README.rdoc
homepage: https://github.com/tardate/pdf-reader-turtletext
licenses:
- MIT
metadata: {}
post_install_message: 
rdoc_options: []
require_paths:
- lib
required_ruby_version: !ruby/object:Gem::Requirement
  requirements:
  - - '>='
    - !ruby/object:Gem::Version
      version: '0'
required_rubygems_version: !ruby/object:Gem::Requirement
  requirements:
  - - '>='
    - !ruby/object:Gem::Version
      version: '0'
requirements: []
rubyforge_project: 
rubygems_version: 2.0.14
signing_key: 
specification_version: 3
summary: PDF structured text reader
test_files: []

