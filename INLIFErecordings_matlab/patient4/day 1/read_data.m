function [X, y] = read_data(filename)
        
        data = csvread(filename);
        X = data(:,1:end - 1);
        y = data(:,end);
        
end