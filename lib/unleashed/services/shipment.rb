module Services
  class Shipment < Base

    def get
      response = request('SalesShipments')
      response["Items"].map { |order| serialize_shipment(order) }
    end

    def serialize_shipment(shipment)
      {
        id: shipment['ShipmentNumber'],
        status: 'shipped',
        order_number: shipment['OrderNumber'],
        bigcommerce_id: shipment['Guid']
      }
    end
  end
end
