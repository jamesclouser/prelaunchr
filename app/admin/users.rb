ActiveAdmin.register User do
  actions :index, :show, :edit, :destroy, :update, :new, :create
  index do
    column :name
    column :email
    column :referral_code
    column :infusionsoft_affiliate_link
    column :referrer_id
    default_actions
  end

  controller do
    def max_csv_records
      30_000
    end
  end

  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :infusionsoft_affiliate_link
    end
    f.actions
  end

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("user", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
end
