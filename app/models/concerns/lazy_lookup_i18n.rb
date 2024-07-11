module LazyLookupI18n
  extend ActiveSupport::Concern

  class_methods do
    def t i18n_key, options = {}
      if superclass != Object
        super_prefix_key = superclass.name.underscore.tr "/", "."
        default = I18n.t("#{super_prefix_key}#{i18n_key}", options)
      end

      prefix_key = name.underscore.tr "/", "."
      I18n.t("#{prefix_key}#{i18n_key}", options.merge(default: default))
    end
  end

  def t i18n_key, options = {}
    self.class.t i18n_key, options
  end
end
