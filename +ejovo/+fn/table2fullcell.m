function C = table2fullcell(tbl)
%TABLE2FULLCELL - converts a table to a cell conserving row and column names
%
%Syntax:
%
%   C = ejovo.fn.table2fullcell(tbl)
%
%Inputs:
%   
%   tbl - the table that you want to convert
%
%Outputs:
%
%   C - the cell that you want to convert to, which includes the variable
%   names in the first row and the row names for its first column.
%
%ejovo.fn.table2fullcell is an extension of the MATLAB function table2cell,
%which fails to capture the row names and variable names in the cell.
%
%ejovo.fn.table2fullcell facilitates the exporting of a table to an excel file.
%
%If no row names exist, then ejovo.fn.table2fullcell will output a cell with
%just the column names included.
    tRows = tbl.Properties.RowNames;
    tBody = table2cell(tbl);
    tCols = tbl.Properties.VariableNames;
    
    C = [tCols; tBody];
    if ~isempty(tRows)
        tRows = [{' '}; tRows];
        C = [tRows C];
    end    
end

