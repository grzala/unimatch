CarrierWave.configure do |config|

    config.root = Rails.root.join('public')
    config.storage = :file
    config.ignore_processing_errors = true
end