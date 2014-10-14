module Services
  class Shipment < Base

    def get
      create_query_string

      response = request('SalesShipments')
      get_last_update(response)

      response["Items"].map { |order| serialize_shipment(order) }
    end

    private

    def serialize_shipment(shipment)
      {
        id:           shipment['ShipmentNumber'],
        status:       'shipped',
        tracking:     shipment['TrackingNumber'],
        order_id:     shipment['OrderNumber'],
        unleashed_id: shipment['Guid'],
        shipped_at:   parse_date(shipment['DispatchDate'])
      }
    end

    def create_query_string
      @query_string = "?modifiedSince=#{modified_since}&shipmentStatus=dispatched"
    end
  end
end
