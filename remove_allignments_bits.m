% Copyright 2017
% 
% Authors: Alessandro Budroni, Ermes Franch, Giuseppe Giffone
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

% Remove the various finder puttin the null value
function [ qr_matrix ] = remove_allignments_bits( qr_matrix, version)
%value for pointless bit
global null;
null = -1;
side = size(qr_matrix,1);
%qr_matrix = qr_matrix*255;
%%Remove position detection pattern (i 3 quadratoni)
%remove up left
qr_matrix(1:9,1:9) = null;
%remove up right
qr_matrix(1:9,side-7:side)=null;
%remove down left
qr_matrix(side-7:side, 1:9)=null;

%%remove timing patterns (le linee)
qr_matrix(7,:) = null;
qr_matrix(:,7) = null;

%%removing allignement patterns
%TODO:modify for center x,y
if version >1
    centers = get_allignment_patterns_center(version);
    %if the centers are more then one

    for c=centers
        qr_matrix(c.r-2:c.r+2,c.c-2:c.c+2) = null;
    end
end
%removing version information if version is bigger then 6
if version > 6
    %down left
    qr_matrix([(size(qr_matrix)-10):(size(qr_matrix)-8)], [1:6]) = null;
    %up right
    qr_matrix([1:6], [(size(qr_matrix)-10):(size(qr_matrix)-8)]) = null;
end
end



%%return the center of the allignemts patterns
function [ result ] = get_allignment_patterns_center( v )
%TODO: edit center in case bigger then 7
if v>1
    switch v
        case 2
            rc =18;
        case 3
            rc = 22;
        case 4
            rc = 26;
        case 5
            rc = 30;
        case 6
            rc = 34;
        case 7
            rc=[22 38];
        case 8
            rc=[24 42];
        case 9
            rc=[26 46];
        case 10
            rc=[28 50];
        case 11
            rc=[30 54];
        case 12
            rc=[32 58];
        case 13
            rc=[34 62];
        case 14
            rc =[26 46 66];
        case 15
            rc =[26 48 70];
        case 16
            rc =[26 50 74];
        case 17
            rc =[30 54 78];
        case 18
            rc =[30 56 82];
        case 19
            rc =[30 58 86];
        case 20
            rc =[34 62 90];
        case  21
            rc=[28 50 72 94];
        case  22
            rc=[26 50 74 98];
        case  23
            rc=[30 54 78 102];
        case  24
            rc=[ 28 54 80 106];
        case  25
            rc=[32 58 86 114];
        case  26
            rc=[ 30 58 86 114];
        case  27
            rc=[ 34 62 90 118];
        case  28
            rc=[26 50 74 98 122 ];
        case  29
            rc=[30 54 78 102 126 ];
        case  30
            rc=[26 52 78 104 130 ];
        case  31
            rc=[ 30 56 82 108 134];
        case  32
            rc=[ 34 60 86 112 138];
        case  33
            rc=[30 58 86 114 142 ];
        case  34
            rc=[34 62 90 118 146 ];
        case  35
            rc=[30 54 78 102 126 150];
        case  36
            rc=[24 50 76 102 128 154];
        case  37
            rc=[28 54 80 106 132 158 ];
        case  38
            rc=[32 58 84 110 136 162];
        case  39
            rc=[26 54 82 110 138 166];
        case 40
            rc = [30 58 86 114 142 170];
    end
    %size qr
    s = 21+(v-1)*4;
    %initialize result
    result=[];
    %add 6 since it is present a the beginning of all rc vector
    rc =[6 rc];
    %calculate max and min for avoid the 3 corner in the if
    M = max(rc);
    m = min(rc);
    for r =rc
        for c=rc
            %evito i quadratoni nei tre bordi
            if (c~=M|| r~=M)&&(c~=m || r~=m) && ...
                    (r~=M || c~=m)
                result = [result struct('r',s-r,'c',c+1)]; 
            end
        end
    end
end

end

