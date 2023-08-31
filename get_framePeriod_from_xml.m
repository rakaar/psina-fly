function framePeriodValue = get_framePeriod_from_xml(filepath)
% Read the XML file
docNode = xmlread(filepath); % Replace 'your_file_path.xml' with the path to your XML file

% Get all PVStateValue elements
allPVStateValueItems = docNode.getElementsByTagName('PVStateValue');

% Initialize an empty value for framePeriod
framePeriod = '';

% Loop through all PVStateValue elements
for k = 0:allPVStateValueItems.getLength-1
    thisItem = allPVStateValueItems.item(k); % Get the current item
    thisKey = char(thisItem.getAttribute('key')); % Get the 'key' attribute
    if strcmp(thisKey, 'framePeriod') % Check if the key is 'framePeriod'
        framePeriod = char(thisItem.getAttribute('value')); % Get the value attribute
        break; % Exit the loop since we found our value
    end
end

% Convert framePeriod string to a double
framePeriodValue = str2double(framePeriod);
end