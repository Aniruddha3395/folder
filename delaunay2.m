clc;
clear all;
close all;

%% input points

pts = [1,1;
    6,6;
    12,1;
    4,8;
    7,9;
    9,3;
    2,12;
    10,11
    ];
pts = [pts,[1:size(pts,1)]'];
scatter(pts(:,1),pts(:,2),'.');         %showing points

% all points are denoted by [x y index]

%% delaunay triangulation by matlab

% tri = delaunay(pts(:,1:2));      %delaunay triangulation using MATLAB
% patch('Faces',tri,'Vertices',pts,'FaceColor','none');

%% algorihm

% creating the super triangle which will contain all the points inside it
xmax = max(pts(:,1));       xmin = min(pts(:,1));
ymax = max(pts(:,2));       ymin = min(pts(:,2));
spacing = 10;
p1_s = [xmin-spacing,ymin-spacing,size(pts,1)+1];
p2_s = [xmax+spacing,ymin-spacing,size(pts,1)+2];
p3_s = [0.5*(xmax+xmin),ymax+spacing,size(pts,1)+3];
pts_new = [pts;p1_s;p2_s;p3_s];
tri_s = [p1_s(1,3),p2_s(1,3),p3_s(1,3)];


tri = [tri_s];
tri_main = [];
edgep= [];
bt = [];
gt = [];
bt_edges = [];
for i1 = 1:3
%     hold on;
figure;
    scatter(pts(i1,1),pts(i1,2),'g');
    for j = 1:size(tri,1)           % for loop for triangles
        [center,r] = circumc(pts_new(tri(j,1),1:2),...
            pts_new(tri(j,2),1:2),...
            pts_new(tri(j,3),1:2));         % getting center anbd radius of the circumcircle
        
        if (pts(i1,1)-center(1))^2 + (pts(i1,2)-center(2))^2-r^2 <0
            fprintf('\ninside the circle\n');
            bt = [bt;tri(j,:)];
            bt_edges = [bt_edges;bt(1,1),bt(1,2);bt(1,1),bt(1,3)...
                ;bt(1,2),bt(1,3)];
        else
            fprintf('\non or outside the circle\n');
            gt = [gt;tri(j,:)]
        end
    end
        for i = 1:size(bt_edges,1)
            if bt_edges(i,1)>bt_edges(i,2)
                bt_edges(i,:) = fliplr(bt_edges(i,:));
            end
        end
    

        chk = bt_edges
    for i = 1:size(bt_edges,1)
        uval = ismember(bt_edges,bt_edges(i,:),'rows');
        if sum(uval)==1
            edgep = [edgep;bt_edges(i,:)]     %edge of polygon
        end
    end
    
    %plotting polygon
     for k1 = 1: size(edgep,1)
        plot_poly = [pts_new(edgep(k1,1),1:2);pts_new(edgep(k1,2),1:2)];
        hold on;
        plot(plot_poly(:,1),plot_poly(:,2),'k','LineWidth',2)
    end
    
    %triangulation
    tri = [edgep,i1.*ones(size(edgep,1),1)]
    
    % potting triangles
    
    for k = 1: size(tri,1)
        plot_pts = [pts_new(tri(k,1),1:2);pts_new(tri(k,2),1:2);...
            pts_new(tri(k,3),1:2);pts_new(tri(k,1),1:2)];
        hold on;
        plot(plot_pts(:,1),plot_pts(:,2),'r')
    end
    
    
    bt = [];
    bad_edges = [];
    edgep = [];
end

% figure;
% scatter(pts(:,1),pts(:,2),'.'); 
% hold on;
% for k = 1: size(gt,1)
%         plot_pts = [pts_new(gt(k,1),1:2);pts_new(gt(k,2),1:2);...
%             pts_new(gt(k,3),1:2);pts_new(gt(k,1),1:2)];
%         hold on;
%         plot(plot_pts(:,1),plot_pts(:,2),'k')
% end
    

% hold on;
%  plot_pts = [pts_new(9,1:2);pts_new(11,1:2);...
%                 pts_new(1,1:2);pts_new(9,1:2)];
%        plot(plot_pts(:,1),plot_pts(:,2),'LineWidth',2)