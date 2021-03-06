motion_require '../helpers/has_authorization'
motion_require './_nano_bag_mixin.rb'
motion_require './_finder_mixin.rb'
motion_require './_base_mixin.rb'
motion_require './_sync_mixin.rb'
motion_require './_association_mixin.rb'
motion_require './_dirty_mixin.rb'
motion_require './store.rb'
motion_require './store_extension.rb'
module MotionPrime
  class Model < NSFNanoObject
    include MotionPrime::HasAuthorization
    include MotionPrime::HasNormalizer
    include MotionPrime::ModelBaseMixin
    include MotionPrime::ModelAssociationMixin
    include MotionPrime::ModelSyncMixin
    include MotionPrime::ModelFinderMixin
    include MotionPrime::ModelDirtyMixin

    attribute :bag_key # need this as we use shared store; each nested resource must belong to parent bag
    attribute :id

    def errors
      @errors ||= Errors.new(self.weak_ref)
    end

    def set_errors(data)
      errors.track_changed do
        data.symbolize_keys.each do |key, error_messages|
          errors.set(key, error_messages, silent: true) if error_messages.present?
        end
      end
    end

    def dealloc
      Prime.logger.dealloc_message :model, self
      super
    end
  end
end