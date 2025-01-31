json.extract! medicine, :id, :name, :exp_date, :form, :manufacturer, :category_id, :batch_no, :prescribed, :created_at, :updated_at
json.url medicine_url(medicine, format: :json)
