function ZoomedImage = NearestNeighbourZooming(original, new_size)
  original_size = size(original);
  pixel_boundary =  1 ./original_size;
  new_step_size = 1 ./ new_size;
  row = min(floor((new_step_size(1)/2:new_step_size(1):1)./pixel_boundary(1)) + 1, original_size(1));
  column = min(floor((new_step_size(2)/2:new_step_size(2):1)./pixel_boundary(2)) + 1, original_size(2))
  ZoomedImage = original(row, column, :);
