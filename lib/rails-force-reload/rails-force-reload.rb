require 'active_record'

module RailsForceReload

  module DefineReaders
    # this method changed in 5.2.0 to strip arguments
    # See commit 39f6c6c641f0c92c532e0c3747d1536af657920f
    def define_readers(mixin, name)
      mixin.class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{name}(*args)
          association(:#{name}).reader(*args)
        end
      CODE
    end
  end

  ActiveRecord::Associations::Builder::Association.singleton_class.prepend(DefineReaders)

  module Reader
    def reader(force_reload = false)
      klass.uncached { reload } if force_reload && klass
      super()
    end
  end

  ActiveRecord::Associations::SingularAssociation.send(:prepend, Reader)
  ActiveRecord::Associations::CollectionAssociation.send(:prepend, Reader)

end

