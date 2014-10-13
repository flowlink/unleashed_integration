module Services
  class Shipment < Base

    def get
      create_query_string

      response = request('SalesShipments')
      response["Items"].map { |order| serialize_shipment(order) }
    end

    private

    def serialize_shipment(shipment)
      {
        id: shipment['ShipmentNumber'],
        status: 'shipped',
        order_number: shipment['OrderNumber'],
        bigcommerce_id: shipment['Guid']
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}"
    end
  end
end
