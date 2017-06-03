module Api
  module V1
    class ProductsController < ApplicationController
      protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

      def pulls
        data = pull_many(pull_params)

        render json: data
      end

      def search
        data = search_crates(search_params)

        render json: data
      end

      def locations
        data = {}
        data[:locations] = []

        locations = Location.all
        locations.each do |location|
          data[:locations] << location
        end

        render json: data
      end

      private
      def pull_params
        unless params.has_key?(:longitude) && params.has_key?(:latitude)
          return nil
        else
          params.permit(:place, :longitude, :latitude)
        end
      end

      def pull_many(req)
        data = {}
        location = nil
        long = nil
        lat = nil


        if !req.nil? && req[:longitude].present? && req[:latitude].present?
          long = req[:longitude]
          lat = req[:latitude]
          location = Location.where(lng: long, lat: lat).first

          if location == nil
            crates = Crate.where(locations_id: 999999)
          else
            crates = Crate.where(locations_id: location.id)
            data[:place] = location.name
            data[:longitude] = location.lng
            data[:latitude] = location.lat
          end

        else
          crates = Crate.all
        end

        data[:crates] = [];
        crates.each do |crate|
          pics = [];
          pictures = crate.pictures
          pictures.each do |picture|
            pics.push(request.host + picture.image.url)
          end

          usr = {
            alias: crate.user.alias,
            mobile: crate.user.profile.phone_number
          }

          crate = crate.to_hash
          crate[:pictures] = pics
          crate[:user] = usr

          data[:crates] << crate
        end

        data
      end

      def search_params
        unless params.has_key?(:q)
          return nil
        else
          params.permit(:q)
        end
      end

      def search_crates(req)
        data = {}
        q = nil

        data[:crates] = [];
        if !req.nil? && req[:q].present?
          crates = Crate.where('name LIKE ?', '%' + req[:q] + '%')
          crates.each do |crate|
            data[:crates] << crate
          end
        end

        data
      end

    end
  end
end
