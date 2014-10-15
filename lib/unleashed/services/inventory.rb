module Services
  class Inventory < Base

    def get
      create_query_string

      response = request('StockOnHand')
      get_last_update(response)

      response["Items"].map { |order| serialize_inventory(order) }
    end

    def create(inventory)
      get_guid

      post_request("StockAdjustments/#{@guid}", serialize_for_post(inventory))

      { id: inventory["id"], unleashed_id: @guid }
    end

    private

    def serialize_inventory(inventory)
      {
        id:           inventory['ProductCode'],
        product_id:   inventory['ProductCode'],
        unleashed_id: inventory['Guid'],
        location:     inventory['Warehouse'],
        quantity:     inventory['AvailableQty']
      }
    end

    def serialize_for_post(inventory)
      warehouse = find_warehouse(inventory["location"])
      product   = find_product(inventory['id'])

      {
        "Guid" => @guid,
        "Warehouse"  => {
          "WarehouseName" => warehouse["WarehouseName"],
          "WarehouseCode" => warehouse["WarehouseCode"]
          },
        "AdjustmentReason"  => inventory["reason"],
        "Guid" => @guid,
        "StockAdjustmentLines" => [{
          "Guid" => SecureRandom.uuid,
          "NewQuantity" => inventory["quantity"],
          "NewActualValue"    => inventory["quantity"].to_f * product["LastCost"].to_f,
          "Product"  => {
            "ProductCode" => product["ProductCode"],
            "ProductDescription" => product["ProductDescription"],
            "Guid" => product["Guid"]
          }
        }]
      }
    end

    def get_guid
      @guid ||= SecureRandom.uuid
    end

    def find_warehouse(warehouse)
      @query_string = ''
      houses = request('Warehouses')

      house = houses["Items"].select { |wh|
        wh["WarehouseName"].downcase == warehouse.downcase
      }.first

      raise RecordNotFound, "Could not find warehouse for #{warehouse}" unless house
      house
    end

    def find_product(id)
      @query_string = "?productCode=#{id}"
      product = request('Products')["Items"].first

      raise RecordNotFound, "Could not find product for #{id}" unless product
      product
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end

class RecordNotFound < StandardError; end