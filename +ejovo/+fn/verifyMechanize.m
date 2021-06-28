function isInstalled = verifyMechanize
%VERIFYMECHANIZE Check if the perl module WWW::Mechanize is installed
%  If installed, return true. If not installed, return false.

    perlCommand = "perl -e 'use WWW::Mechanize'";
    [~, output] = system(perlCommand);
    
    
    %isInstalled = status;
    %disp(output);
    
    lenOutput = length(output);
    %disp(lenOutput);

    if (lenOutput > 0)
        isInstalled = false;
    else
        isInstalled = true;
    end
end

