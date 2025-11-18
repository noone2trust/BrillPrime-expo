-- Missing PostGIS Function for Finding Nearby Merchants
-- This function is used by the merchants-nearby edge function

-- Function to find merchants within a given radius
CREATE OR REPLACE FUNCTION nearby_merchants(
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 10
)
RETURNS TABLE (
  id UUID,
  business_name TEXT,
  business_type TEXT,
  address TEXT,
  city TEXT,
  state TEXT,
  rating DECIMAL,
  total_reviews INTEGER,
  is_verified BOOLEAN,
  is_active BOOLEAN,
  distance_km DOUBLE PRECISION,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    m.id,
    m.business_name,
    m.business_type,
    m.address,
    m.city,
    m.state,
    m.rating,
    m.total_reviews,
    m.is_verified,
    m.is_active,
    ST_Distance(
      m.location::geography,
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography
    ) / 1000 AS distance_km,
    ST_Y(m.location::geometry) AS latitude,
    ST_X(m.location::geometry) AS longitude
  FROM merchants m
  WHERE m.is_active = true
    AND ST_DWithin(
      m.location::geography,
      ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
      radius_km * 1000
    )
  ORDER BY distance_km ASC;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION nearby_merchants(DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION) TO authenticated;
GRANT EXECUTE ON FUNCTION nearby_merchants(DOUBLE PRECISION, DOUBLE PRECISION, DOUBLE PRECISION) TO anon;
