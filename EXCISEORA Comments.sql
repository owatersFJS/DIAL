--excise_locations

COMMENT ON TABLE excise_locations IS
    'Stores registered locations relevant to UK excise and customs operations, including warehouses, depots, and bonded facilities.';

COMMENT ON COLUMN excise_locations.location_id IS
    'Unique identifier for the excise location, generated automatically.';

COMMENT ON COLUMN excise_locations.name IS
    'Name of the excise location, such as a warehouse, depot, or facility.';

COMMENT ON COLUMN excise_locations.address_line1 IS
    'Primary address line for the excise location.';

COMMENT ON COLUMN excise_locations.address_line2 IS
    'Secondary address line for the excise location (optional).';

COMMENT ON COLUMN excise_locations.city IS
    'City in which the excise location is situated.';

COMMENT ON COLUMN excise_locations.postal_code IS
    'Postal code associated with the excise location address.';

COMMENT ON COLUMN excise_locations.country_code IS
    'ISO 3166-1 alpha-2 country code representing the location''s country.';

COMMENT ON COLUMN excise_locations.latitude IS
    'Geographical latitude coordinate of the location, used for geospatial processing.';

COMMENT ON COLUMN excise_locations.longitude IS
    'Geographical longitude coordinate of the location, used for geospatial processing.';

COMMENT ON COLUMN excise_locations.created IS
    'Date and time when the record was first created.';

COMMENT ON COLUMN excise_locations.created_by IS
    'User or system identifier that created the record.';

COMMENT ON COLUMN excise_locations.updated IS
    'Date and time when the record was last updated.';

COMMENT ON COLUMN excise_locations.updated_by IS
    'User or system identifier that last updated the record.';

--excise_parties

COMMENT ON TABLE excise_parties IS
    'Represents individuals or organisations involved in UK excise and customs activities, such as traders, declarants, warehouse operators, or transporters.';

COMMENT ON COLUMN excise_parties.party_id IS
    'Unique identifier for the party, generated automatically.';

COMMENT ON COLUMN excise_parties.location_id IS
    'Reference to the associated excise location for the party, where applicable.';

COMMENT ON COLUMN excise_parties.party_type IS
    'Indicates whether the party is a PERSON or an ORGANIZATION.';

COMMENT ON COLUMN excise_parties.name IS
    'Full name of the party, either a personal name or an organisation name.';

COMMENT ON COLUMN excise_parties.email IS
    'Email address for contacting the party.';

COMMENT ON COLUMN excise_parties.phone IS
    'Telephone number for the party.';

COMMENT ON COLUMN excise_parties.created IS
    'Date and time when the party record was first created.';

COMMENT ON COLUMN excise_parties.created_by IS
    'Identifier of the user or system responsible for creating the record.';

COMMENT ON COLUMN excise_parties.updated IS
    'Date and time when the party record was last updated.';

COMMENT ON COLUMN excise_parties.updated_by IS
    'Identifier of the user or system responsible for the last update.';
    
--excise_party_identifiers     

COMMENT ON TABLE excise_party_identifiers IS
    'Stores external identifiers associated with excise parties, such as VAT numbers, EORI numbers, excise registrations, and other regulatory or national identifiers.';

COMMENT ON COLUMN excise_party_identifiers.party_identifier_id IS
    'Unique identifier for the party identifier record, generated automatically.';

COMMENT ON COLUMN excise_party_identifiers.party_id IS
    'Reference to the excise party to whom this identifier belongs.';

COMMENT ON COLUMN excise_party_identifiers.id_type IS
    'Type of identifier, such as VAT, EORI, excise registration, warehouse approval, company number, national ID, or other.';

COMMENT ON COLUMN excise_party_identifiers.id_value IS
    'The actual identifier value issued to the party by the relevant authority.';

COMMENT ON COLUMN excise_party_identifiers.issuing_country IS
    'Two‑letter ISO country code indicating which country issued the identifier.';

COMMENT ON COLUMN excise_party_identifiers.valid_from IS
    'Date from which the identifier is valid.';

COMMENT ON COLUMN excise_party_identifiers.valid_to IS
    'Date until which the identifier is valid, if applicable.';

COMMENT ON COLUMN excise_party_identifiers.created IS
    'Date and time when the identifier record was first created.';

COMMENT ON COLUMN excise_party_identifiers.created_by IS
    'User or system identifier responsible for creating the record.';

COMMENT ON COLUMN excise_party_identifiers.updated IS
    'Date and time when the identifier record was last updated.';

COMMENT ON COLUMN excise_party_identifiers.updated_by IS
    'User or system identifier responsible for the last update.';    
    
--excise_events

COMMENT ON TABLE excise_events IS
    'Represents reportable events in the excise lifecycle, such as production, movement, import, export, duty point changes, losses, and other regulatory events.';

COMMENT ON COLUMN excise_events.event_id IS
    'Unique identifier for the excise event, generated automatically.';

COMMENT ON COLUMN excise_events.duty_point_location_id IS
    'Reference to the excise location where the event occurred or where the duty point is established.';

COMMENT ON COLUMN excise_events.event_type IS
    'Type of excise event, such as production, receipt, import, export, suspension movement, release for consumption, or adjustment.';

COMMENT ON COLUMN excise_events.event_ts IS
    'Timestamp indicating when the excise event occurred.';

COMMENT ON COLUMN excise_events.country_code IS
    'Two‑letter ISO country code indicating where the event took place.';

COMMENT ON COLUMN excise_events.region IS
    'Administrative or geographic region in which the event occurred, if applicable.';

COMMENT ON COLUMN excise_events.authority IS
    'Name of the regulatory or customs authority responsible for overseeing or recording the event.';

COMMENT ON COLUMN excise_events.duty_status IS
    'Duty status at the time of the event, such as duty suspended, duty paid, exempt, or relief claimed.';

COMMENT ON COLUMN excise_events.duty_point_type IS
    'Type of duty point being referenced, such as a warehouse, registered consignee, or tax point classification.';

COMMENT ON COLUMN excise_events.duty_point_ref IS
    'Reference associated with the duty point, such as an approval number, movement reference, or external identifier.';

COMMENT ON COLUMN excise_events.extensions IS
    'Additional event data provided in extensible JSON or XML format.';

COMMENT ON COLUMN excise_events.source_system IS
    'Name of the external or internal system from which the event record originated.';

COMMENT ON COLUMN excise_events.version IS
    'Version number of the event record, used for tracking changes or replayability.';

COMMENT ON COLUMN excise_events.created IS
    'Date and time when the event record was first created.';

COMMENT ON COLUMN excise_events.created_by IS
    'User or system identifier that created the event record.';

COMMENT ON COLUMN excise_events.updated IS
    'Date and time when the event record was last updated.';

COMMENT ON COLUMN excise_events.updated_by IS
    'User or system identifier that last updated the event record.';    

--excise_event_parties

COMMENT ON TABLE excise_event_parties IS
    'Links parties to excise events and describes the role they played, such as consignor, consignee, transporter, or warehouse keeper.';

COMMENT ON COLUMN excise_event_parties.event_party_id IS
    'Unique identifier for the event–party association record, generated automatically.';

COMMENT ON COLUMN excise_event_parties.event_id IS
    'Reference to the excise event with which the party is associated.';

COMMENT ON COLUMN excise_event_parties.pary_id IS
    'Reference to the associated excise party involved in the event.';

COMMENT ON COLUMN excise_event_parties.role IS
    'Role played by the party in the event, such as owner, consignor, consignee, warehouse keeper, transporter, or agent.';

COMMENT ON COLUMN excise_event_parties.created IS
    'Date and time when the event–party record was first created.';

COMMENT ON COLUMN excise_event_parties.created_by IS
    'User or system identifier that created the event–party record.';

COMMENT ON COLUMN excise_event_parties.updated IS
    'Date and time when the event–party record was last updated.';

COMMENT ON COLUMN excise_event_parties.updated_by IS
    'User or system identifier that last updated the event–party record.';    
    
--excise_warehouses

COMMENT ON TABLE excise_warehouses IS
    'Represents excise warehouses approved for storing duty‑suspended goods, including their location, operator, and regulatory approval details.';

COMMENT ON COLUMN excise_warehouses.warehouse_id IS
    'Unique identifier for the excise warehouse, generated automatically.';

COMMENT ON COLUMN excise_warehouses.location_id IS
    'Reference to the physical location of the warehouse.';

COMMENT ON COLUMN excise_warehouses.operator_party_id IS
    'Reference to the party responsible for operating the warehouse, such as a warehouse keeper or authorised business.';

COMMENT ON COLUMN excise_warehouses.warehouse_code IS
    'Internal or external code used to identify the warehouse.';

COMMENT ON COLUMN excise_warehouses.approval_number IS
    'Regulatory approval number issued by the relevant excise or customs authority for operating the warehouse.';

COMMENT ON COLUMN excise_warehouses.created IS
    'Date and time when the warehouse record was first created.';

COMMENT ON COLUMN excise_warehouses.created_by IS
    'User or system identifier that created the warehouse record.';

COMMENT ON COLUMN excise_warehouses.updated IS
    'Date and time when the warehouse record was last updated.';

COMMENT ON COLUMN excise_warehouses.updated_by IS
    'User or system identifier that last updated the warehouse record.';    
    
--excise_event_warehouses

COMMENT ON TABLE excise_event_warehouses IS
    'Associates excise events with specific warehouses involved in the event, such as storage, receipt, dispatch, or movement under duty suspension.';

COMMENT ON COLUMN excise_event_warehouses.event_warehouse_id IS
    'Unique identifier for the event–warehouse association record, generated automatically.';

COMMENT ON COLUMN excise_event_warehouses.event_id IS
    'Reference to the excise event associated with the warehouse.';

COMMENT ON COLUMN excise_event_warehouses.warehouse_id IS
    'Reference to the excise warehouse involved in the event.';

COMMENT ON COLUMN excise_event_warehouses.created IS
    'Date and time when the event–warehouse record was first created.';

COMMENT ON COLUMN excise_event_warehouses.created_by IS
    'User or system identifier that created the event–warehouse record.';

COMMENT ON COLUMN excise_event_warehouses.updated IS
    'Date and time when the event–warehouse record was last updated.';

COMMENT ON COLUMN excise_event_warehouses.updated_by IS
    'User or system identifier that last updated the event–warehouse record.';

--excise_movements

COMMENT ON TABLE excise_movements IS
    'Captures the movement of excise goods between locations, including dispatch, destination, timings, transport mode, and related event information.';

COMMENT ON COLUMN excise_movements.movement_id IS
    'Unique identifier for the excise movement, generated automatically.';

COMMENT ON COLUMN excise_movements.event_id IS
    'Reference to the excise event that initiated or represents this movement.';

COMMENT ON COLUMN excise_movements.dispatch_location_id IS
    'Reference to the location from which the goods were dispatched.';

COMMENT ON COLUMN excise_movements.destination_location_id IS
    'Reference to the intended destination location for the movement.';

COMMENT ON COLUMN excise_movements.movement_type IS
    'Type of movement, such as suspension movement, duty-paid movement, export, import, or internal transfer.';

COMMENT ON COLUMN excise_movements.dispatch_ts IS
    'Timestamp indicating when the goods were dispatched.';

COMMENT ON COLUMN excise_movements.expected_arrival_ts IS
    'Expected arrival timestamp for the goods at their destination.';

COMMENT ON COLUMN excise_movements.transport_mode IS
    'Mode of transport used for the movement, such as road, rail, sea, air, inland waterway, courier, or other.';

COMMENT ON COLUMN excise_movements.vehicle_id IS
    'Identifier for the vehicle used to transport the excise goods, if applicable.';

COMMENT ON COLUMN excise_movements.container_id IS
    'Identifier for the transport container used in the movement, if applicable.';

COMMENT ON COLUMN excise_movements.extensions IS
    'Extensible structured data in JSON or similar format, containing additional movement attributes.';

COMMENT ON COLUMN excise_movements.created IS
    'Date and time when the movement record was first created.';

COMMENT ON COLUMN excise_movements.created_by IS
    'User or system identifier that created the movement record.';

COMMENT ON COLUMN excise_movements.updated IS
    'Date and time when the movement record was last updated.';

COMMENT ON COLUMN excise_movements.updated_by IS
    'User or system identifier that last updated the movement record.';

--excise_movement_references

COMMENT ON TABLE excise_movement_references IS
    'Stores reference numbers associated with excise movements, such as ARC, EAD, customs declarations, or local reference identifiers.';

COMMENT ON COLUMN excise_movement_references.movement_reference_id IS
    'Unique identifier for the movement reference record, generated automatically.';

COMMENT ON COLUMN excise_movement_references.movement_id IS
    'Reference to the excise movement to which this external reference applies.';

COMMENT ON COLUMN excise_movement_references.ref_type IS
    'Type of movement reference, such as ARC, EAD, local reference, customs declaration, or other.';

COMMENT ON COLUMN excise_movement_references.ref_value IS
    'Actual reference value or identifier associated with the movement.';

COMMENT ON COLUMN excise_movement_references.created IS
    'Date and time when the movement reference record was first created.';

COMMENT ON COLUMN excise_movement_references.created_by IS
    'User or system identifier that created the movement reference record.';

COMMENT ON COLUMN excise_movement_references.updated IS
    'Date and time when the movement reference record was last updated.';

COMMENT ON COLUMN excise_movement_references.updated_by IS
    'User or system identifier that last updated the movement reference record.';

--excise_movement_seals

COMMENT ON TABLE excise_movement_seals IS
    'Records seals applied to excise movements for security or regulatory purposes, typically during transport under duty suspension.';

COMMENT ON COLUMN excise_movement_seals.movement_seal_id IS
    'Unique identifier for the movement seal record, generated automatically.';

COMMENT ON COLUMN excise_movement_seals.movement_id IS
    'Reference to the excise movement to which the seal applies.';

COMMENT ON COLUMN excise_movement_seals.seal_number IS
    'Identifier or serial number of the seal applied to the movement.';

COMMENT ON COLUMN excise_movement_seals.created IS
    'Date and time when the movement seal record was first created.';

COMMENT ON COLUMN excise_movement_seals.created_by IS
    'User or system identifier that created the movement seal record.';

COMMENT ON COLUMN excise_movement_seals.updated IS
    'Date and time when the movement seal record was last updated.';

COMMENT ON COLUMN excise_movement_seals.updated_by IS
    'User or system identifier that last updated the movement seal record.';

--excise_items

COMMENT ON TABLE excise_items IS
    'Represents individual excise goods associated with an excise event, including product details, classification, quantity, valuation, and origin information.';

COMMENT ON COLUMN excise_items.item_id IS
    'Unique identifier for the excise item, generated automatically.';

COMMENT ON COLUMN excise_items.event_id IS
    'Reference to the excise event this item is associated with.';

COMMENT ON COLUMN excise_items.category IS
    'High-level excise category of the item, such as alcohol, tobacco, energy products, or other.';

COMMENT ON COLUMN excise_items.sub_category IS
    'More specific classification within the excise category, if applicable.';

COMMENT ON COLUMN excise_items.excise_product_code IS
    'Excise product code (EPC) used for excise duty calculation or classification.';

COMMENT ON COLUMN excise_items.commodity_code IS
    'Customs commodity code (e.g., HS or CN code) used for tariff and customs processing.';

COMMENT ON COLUMN excise_items.description IS
    'Textual description of the excise item, as declared or recorded.';

COMMENT ON COLUMN excise_items.brand IS
    'Brand name associated with the product, if applicable.';

COMMENT ON COLUMN excise_items.qty_amount IS
    'Quantity amount of the item being declared or recorded.';

COMMENT ON COLUMN excise_items.qty_unit IS
    'Unit of measure for the quantity (e.g., litres, kg, units).';

COMMENT ON COLUMN excise_items.origin_country_code IS
    'Two-letter ISO country code indicating the country of origin of the goods.';

COMMENT ON COLUMN excise_items.customs_value IS
    'Customs valuation of the goods, typically used for import duty calculations.';

COMMENT ON COLUMN excise_items.transaction_value IS
    'Declared transaction value of the goods, such as sale or transfer price.';

COMMENT ON COLUMN excise_items.extensions IS
    'Extensible structured data in JSON or similar format containing additional item attributes.';

COMMENT ON COLUMN excise_items.created IS
    'Date and time when the item record was first created.';

COMMENT ON COLUMN excise_items.created_by IS
    'User or system identifier that created the item record.';

COMMENT ON COLUMN excise_items.updated IS
    'Date and time when the item record was last updated.';

COMMENT ON COLUMN excise_items.updated_by IS
    'User or system identifier that last updated the item record.';

--excise_item_strength

COMMENT ON TABLE excise_item_strength IS
    'Captures strength or analytical measurements for excise goods, particularly alcohol products, including ABV, Plato, API gravity, and pure alcohol calculations.';

COMMENT ON COLUMN excise_item_strength.item_strength_id IS
    'Unique identifier for the item strength record, generated automatically.';

COMMENT ON COLUMN excise_item_strength.item_id IS
    'Reference to the excise item for which strength information is recorded.';

COMMENT ON COLUMN excise_item_strength.abv_percent IS
    'Alcohol by volume (ABV) percentage of the product.';

COMMENT ON COLUMN excise_item_strength.plato IS
    'Plato measurement indicating wort sugar concentration, relevant for beer production.';

COMMENT ON COLUMN excise_item_strength.api_gravity IS
    'API gravity measurement, typically used for petroleum and energy products.';

COMMENT ON COLUMN excise_item_strength.litres_of__pure_alcohol IS
    'Calculated litres of pure alcohol (LPA) contained in the item.';

COMMENT ON COLUMN excise_item_strength.created IS
    'Date and time when the item strength record was first created.';

COMMENT ON COLUMN excise_item_strength.created_by IS
    'User or system identifier that created the item strength record.';

COMMENT ON COLUMN excise_item_strength.updated IS
    'Date and time when the item strength record was last updated.';

COMMENT ON COLUMN excise_item_strength.updated_by IS
    'User or system identifier that last updated the item strength record.';

--excise_item_packaging

COMMENT ON TABLE excise_item_packaging IS
    'Describes how excise goods are packaged, including package type, unit counts, and net contents for duty and customs processing.';

COMMENT ON COLUMN excise_item_packaging.item_packaging_id IS
    'Unique identifier for the item packaging record, generated automatically.';

COMMENT ON COLUMN excise_item_packaging.item_id IS
    'Reference to the excise item for which packaging information is recorded.';

COMMENT ON COLUMN excise_item_packaging.package_type IS
    'Type of packaging used, such as bottle, carton, keg, box, or pallet.';

COMMENT ON COLUMN excise_item_packaging.units_per_package IS
    'Number of individual units contained within each package.';

COMMENT ON COLUMN excise_item_packaging.package_count IS
    'Number of packages for the item.';

COMMENT ON COLUMN excise_item_packaging.net_content_amount IS
    'Net content amount per unit or package (e.g., litres per bottle).';

COMMENT ON COLUMN excise_item_packaging.net_content_unit IS
    'Unit of measure for the net content amount.';

COMMENT ON COLUMN excise_item_packaging.created IS
    'Date and time when the item packaging record was first created.';

COMMENT ON COLUMN excise_item_packaging.created_by IS
    'User or system identifier that created the item packaging record.';

COMMENT ON COLUMN excise_item_packaging.updated IS
    'Date and time when the item packaging record was last updated.';

COMMENT ON COLUMN excise_item_packaging.updated_by IS
    'User or system identifier that last updated the item packaging record.';

--excise_item_relief

COMMENT ON TABLE excise_item_relief IS
    'Records excise reliefs or exemptions applied to specific items, including relief type, reference, and calculated relief amount.';

COMMENT ON COLUMN excise_item_relief.item_relief_id IS
    'Unique identifier for the item relief record, generated automatically.';

COMMENT ON COLUMN excise_item_relief.item_id IS
    'Reference to the excise item for which the relief applies.';

COMMENT ON COLUMN excise_item_relief.relief_type IS
    'Type of relief applied to the item, such as exemption, reduced rate, drawback, or other relief category.';

COMMENT ON COLUMN excise_item_relief.relief_reference IS
    'Reference or approval document associated with the relief, if applicable.';

COMMENT ON COLUMN excise_item_relief.relief_amount IS
    'Amount of excise relief granted for the item.';

COMMENT ON COLUMN excise_item_relief.extensions IS
    'Extensible structured data in JSON or similar format containing additional relief-related attributes.';

COMMENT ON COLUMN excise_item_relief.created IS
    'Date and time when the item relief record was first created.';

COMMENT ON COLUMN excise_item_relief.created_by IS
    'User or system identifier that created the item relief record.';

COMMENT ON COLUMN excise_item_relief.updated IS
    'Date and time when the item relief record was last updated.';

COMMENT ON COLUMN excise_item_relief.updated_by IS
    'User or system identifier that last updated the item relief record.';

--excise_tax_calculations

COMMENT ON TABLE excise_tax_calculations IS
    'Stores aggregated excise and related tax calculations for a given excise event, including totals, currency, and method used.';

COMMENT ON COLUMN excise_tax_calculations.tax_calc_id IS
    'Unique identifier for the tax calculation record, generated automatically.';

COMMENT ON COLUMN excise_tax_calculations.event_id IS
    'Reference to the excise event for which tax has been calculated.';

COMMENT ON COLUMN excise_tax_calculations.currency IS
    'Three-letter ISO currency code in which the tax amounts are calculated.';

COMMENT ON COLUMN excise_tax_calculations.calculation_method IS
    'Description or identifier of the method or ruleset used to perform the tax calculation.';

COMMENT ON COLUMN excise_tax_calculations.excise_duty_total IS
    'Total excise duty amount calculated for the event.';

COMMENT ON COLUMN excise_tax_calculations.other_tax_total IS
    'Total additional taxes calculated for the event, such as environmental levies.';

COMMENT ON COLUMN excise_tax_calculations.grand_total IS
    'Overall total tax amount, including excise duty and other applicable taxes.';

COMMENT ON COLUMN excise_tax_calculations.created IS
    'Date and time when the tax calculation record was first created.';

COMMENT ON COLUMN excise_tax_calculations.created_by IS
    'User or system identifier that created the tax calculation record.';

COMMENT ON COLUMN excise_tax_calculations.updated IS
    'Date and time when the tax calculation record was last updated.';

COMMENT ON COLUMN excise_tax_calculations.updated_by IS
    'User or system identifier that last updated the tax calculation record.';

--excise_tax_lines

COMMENT ON TABLE excise_tax_lines IS
    'Represents detailed line-level tax calculations for items within an excise event, including rates, bases, quantities, and reliefs.';

COMMENT ON COLUMN excise_tax_lines.tax_line_id IS
    'Unique identifier for the tax calculation line, generated automatically.';

COMMENT ON COLUMN excise_tax_lines.tax_calc_id IS
    'Reference to the parent tax calculation summary record.';

COMMENT ON COLUMN excise_tax_lines.item_id IS
    'Reference to the excise item associated with this tax line, if applicable.';

COMMENT ON COLUMN excise_tax_lines.tax_type IS
    'Type of tax being applied, such as excise duty, environmental levy, or other category.';

COMMENT ON COLUMN excise_tax_lines.rate_amount IS
    'Tax rate amount used in the calculation, expressed in the unit defined by the rate basis.';

COMMENT ON COLUMN excise_tax_lines.rate_basis IS
    'Basis upon which the tax rate is applied, such as per litre, per kilogram, or per unit.';

COMMENT ON COLUMN excise_tax_lines.taxable_qty_amount IS
    'Quantity amount subject to taxation.';

COMMENT ON COLUMN excise_tax_lines.taxable_qty_unit IS
    'Unit of measure for the taxable quantity.';

COMMENT ON COLUMN excise_tax_lines.relief_applied IS
    'Amount of relief applied to the tax line, if applicable.';

COMMENT ON COLUMN excise_tax_lines.tax_amount IS
    'Final calculated tax amount for the line after applying rates and reliefs.';

COMMENT ON COLUMN excise_tax_lines.calculation_notes IS
    'Optional notes or explanatory text related to how the tax was calculated.';

COMMENT ON COLUMN excise_tax_lines.extensions IS
    'Extensible structured data in JSON or similar format containing additional tax attributes.';

COMMENT ON COLUMN excise_tax_lines.created IS
    'Date and time when the tax line record was first created.';

COMMENT ON COLUMN excise_tax_lines.created_by IS
    'User or system identifier that created the tax line record.';

COMMENT ON COLUMN excise_tax_lines.updated IS
    'Date and time when the tax line record was last updated.';

COMMENT ON COLUMN excise_tax_lines.updated_by IS
    'User or system identifier that last updated the tax line record.';
    
--

COMMENT ON TABLE excise_evidence IS
    'Stores supporting evidence documents associated with excise events, such as invoices, transport documents, warehouse records, laboratory certificates, customs declarations, loss reports, and destruction certificates.';

COMMENT ON COLUMN excise_evidence.evidence_id IS
    'Unique identifier for the evidence record, generated automatically.';

COMMENT ON COLUMN excise_evidence.event_id IS
    'Reference to the excise event for which the evidence is provided.';

COMMENT ON COLUMN excise_evidence.evidence_type IS
    'Type of evidence document, such as commercial invoice, transport document, warehouse record, laboratory certificate, customs declaration, loss report, destruction certificate, or other.';

COMMENT ON COLUMN excise_evidence.reference IS
    'Reference number or identifier associated with the evidence document.';

COMMENT ON COLUMN excise_evidence.issued_by IS
    'Name of the organisation or authority that issued the evidence document.';

COMMENT ON COLUMN excise_evidence.issued_date IS
    'Date on which the evidence document was issued.';

COMMENT ON COLUMN excise_evidence.uri IS
    'URI or external link pointing to the location of the evidence document, if applicable.';

COMMENT ON COLUMN excise_evidence.evidence IS
    'Binary content of the evidence document stored as a BLOB.';

COMMENT ON COLUMN excise_evidence.evidence_filename IS
    'Original filename of the uploaded evidence document.';

COMMENT ON COLUMN excise_evidence.evidence_mimetype IS
    'MIME type of the evidence document, indicating its format.';

COMMENT ON COLUMN excise_evidence.evidence_charset IS
    'Character set of the evidence document, if applicable.';

COMMENT ON COLUMN excise_evidence.evidence_lastupd IS
    'Date when the evidence document was last updated or replaced.';

COMMENT ON COLUMN excise_evidence.created IS
    'Date and time when the evidence record was first created.';

COMMENT ON COLUMN excise_evidence.created_by IS
    'User or system identifier that created the evidence record.';

COMMENT ON COLUMN excise_evidence.updated IS
    'Date and time when the evidence record was last updated.';

COMMENT ON COLUMN excise_evidence.updated_by IS
    'User or system identifier that last updated the evidence record.';

    