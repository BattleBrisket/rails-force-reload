module RailsForceReload

  Dir[File.dirname(__FILE__) + '/rails-force-reload/*.rb'].each do |file|
    require file
  end

end
