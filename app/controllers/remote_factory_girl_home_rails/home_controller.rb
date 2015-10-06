require 'remote_factory_girl_home_rails/serializer'

module RemoteFactoryGirlHomeRails
  class HomeController < ApplicationController

    skip_before_filter *RemoteFactoryGirlHomeRails.skip_before_filter

    def create
      if RemoteFactoryGirlHomeRails.enabled?
        factory_attributes = Array(factory_name(params)) + attributes(params)
        resource = FactoryGirl.create(*factory_attributes)
        render json: Serializer.serialize(resource)
      else
        forbidden = 403
        render json: { status: forbidden }, status: forbidden
      end
    end

    def index
      factories = FactoryGirl.factories.map(&:name)
      render json: { factories: factories }
    end

    private

    def factory_name(params)
      params['factory'].to_sym
    end

    def attributes(params)
      Array(params['attributes']).map { |t| t.to_sym if t.is_a? String }
    end
  end
end
