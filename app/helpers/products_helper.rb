module ProductsHelper
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end

  def link_to_switch_image_upload(name)
    link_to_function(name, "switch_image_upload(this)");
  end

  def reordering_js(table_name)
    "
    $().ready(function() {
      $('##{table_name}').tableDnD({
        dragHandle: 'draghandle',
        onDragClass: 'ondrag',
        onDrop: function(table, row) {
          $.ajax({
            type: 'POST',
            url: '#{url_for(:action => 'sort')}',
            processData: false,
            data: $.tableDnD.serialize() + '&authenticity_token=' + encodeURIComponent('#{form_authenticity_token if protect_against_forgery?}')
          });
        }
      })
    })
    "
  end

end
