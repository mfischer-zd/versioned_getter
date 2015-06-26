require 'spec_helper'

require 'versioned_getter'

class TestBackend
  include Singleton

  @@store = {
    '/characters/1' => 'Homer Simpson',
    '/store/versions/current_version' => '1',
    '/store/versions/1/locations/2' => 'San Francisco',
    '/store/versions/1/products/versions/current_version' => '17',
    '/store/versions/1/products/versions/17/3' => 'red table',
  }

  def get(key)
    @@store[key]
  end
end


describe 'basic query' do
  let(:getter) { VersionedGetter.new(TestBackend.instance) }

  it 'fetches the correct unversioned value' do
    expect(getter.get('/characters/1')).to eql('Homer Simpson')
  end

  it 'fetches the correct versioned value (non-nested case)' do
    expect(getter.get('/store/locations/2')).to eql('San Francisco')
  end

  it 'fetches the correct versioned value (nested case)' do
    expect(getter.get('/store/products/3')).to eql('red table')
  end
end

