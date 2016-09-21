module FastVersioning
  class ValueChange
    def initialize(version:)
      @version = version
      @item = version.item
    end

    def value_was(name)
      if can_use_changeset?(name)
        @version.changeset[name][0]
      else
        item_was.send(name)
      end
    end

    def value_became(name)
      if can_use_changeset?(name)
        @version.changeset[name][1]
      else
        item_became.send(name)
      end
    end

    private

    def can_use_changeset?(name)
      @version.respond_to?(:changeset) && @version.changeset[name].present?
    end

    # TODO: support different paper_trail versions
    def item_was
      @item_was ||= @version.reify(dup: true) || @item.class.new
    end

    # TODO: support different paper_trail versions
    def item_became
      @item_became ||= @version.next.present? ? @version.next.reify(dup: true) : @item
    end
  end
end
