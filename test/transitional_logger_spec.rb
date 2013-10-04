require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'
require_relative '../lib/transitional_logger'

describe TransitionalLogger do

  before { TransitionalLogger.reset }

  it '#reset clears #logger from Object' do
    TransitionalLogger.stdout
    TransitionalLogger.reset
    Object.wont_respond_to :logger
  end

  it 'responds to info' do
    TransitionalLogger.stdout
    TransitionalLogger.logger.must_respond_to :info
  end

  it 'responds to error' do
    TransitionalLogger.stdout
    TransitionalLogger.logger.must_respond_to :error
  end

  it '#infect_object creates Object#logger, which returns param' do
    TransitionalLogger.send :infect_object, 2
    Object.new.logger.must_equal 2
  end

  it 'puts should not normally delegate to logger' do
    TransitionalLogger.expects(:infect_object).returns(Logger.new('/dev/null'))
    TransitionalLogger.stdout
    TransitionalLogger.logger.expects(:info).never
    puts 'rem: test case sequence varies'
  end

  it '#file should result in puts delegating to logger' do
    TransitionalLogger.stdout
    TransitionalLogger.file('/dev/null')
    TransitionalLogger.logger.expects(:info).at_least_once
    puts 'hi'
  end

  it '#file requires args' do
    lambda {TransitionalLogger.file}.must_raise ArgumentError
  end

end
