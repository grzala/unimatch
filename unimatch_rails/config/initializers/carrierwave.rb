CarrierWave.configure do |config|

    config.root = Rails.root.join('public')
    config.storage = :file
end