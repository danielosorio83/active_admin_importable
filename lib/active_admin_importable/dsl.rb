module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      action_item :view, only: :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", action: 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, method: :post do
        current_user = send(active_admin_config.namespace.application.current_user_method)
        if params[:dump][:file].original_filename.match(/\.xls/)
          XlsDb.convert_save(active_admin_config.resource_class, params[:dump][:file], current_user, &block)
        else
          CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], current_user, &block)
        end
        redirect_to action: :index, notice: "#{active_admin_config.resource_name.to_s} imported successfully!"
      end
    end
  end
end
