# TransitionalLogger

A singleton logger accessible from ALL objects. It is intended to be used to:

* send logger data to stdout OR
* log to a file while consuming stdout & stderr data as log input OR
* destroy stdout, stderr, & log data OR
* do one of the above until transitioned to another of the above

## Installation

Add this line to your application's Gemfile:

    gem 'transitional_logger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transitional_logger

## Usage

The logger can be altered just like a normal Logger:

	logger.level = Logger::WARN

Example usage:

	TransitionalLogger.stdout
	logger.info 'this message goes through the logger to stdout'
	puts 'this works like usual'

	TransitionalLogger.file('/tmp/whatever.log')
	Object.new.logger.info 'this message goes through the logger to the file above'
	puts 'this message also goes through the logger above'

	TransitionalLogger.blackhole
	Object.new.logger.error 'this message disappears'
	puts 'this message disappears too!'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
