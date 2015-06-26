require 'singleton'

class VersionedGetter
  # backend should be an object that provides a 'get(String) -> String' function
  def initialize(backend)
    @backend = backend
  end

  def get(key, start_index=0)
    # Easy case
    val = @backend.get(key)
    return val if val

    components = key.split('/')
    start_index.upto(components.length - 2) do |pivot|
      head = components[0..pivot].join('/')
      tail = components[pivot+1..-1].join('/')
      current_version = @backend.get(head + '/versions/current_version')
      if current_version
        versioned_key = head + "/versions/#{current_version}/" + tail
        return get(versioned_key, pivot + 2)
      end
    end
    nil
  end
end
