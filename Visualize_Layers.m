function Visualize_Layers(V,dx,dy,dz,dt)
V=squeeze(V);

[Nx,Ny,Nz,Nt]=size(V);
x=0:dx:(Nx-1)*dx;
y=0:dy:(Ny-1)*dy;
z=0:-dz:-(Nz-1)*dz;
[X,Y,Z]=meshgrid(x,y,z);

xq=0:dx/4:(Nx-1)*dx;
yq=0:dy/4:(Ny-1)*dy;
zq=0:-dz:-(Nz-1)*dz;
[Xq,Yq,Zq]=meshgrid(xq,yq,zq);
xslice=[max(x)];
yslice=[max(y)];
zslice=z;
% slice(X,Y,Z,V(:,:,:,10),xslice,yslice,zslice)

lvls = linspace(min(V(:)),max(V(:)),100);
% contourslice(X,Y,Z,V(:,:,:,10),xslice,yslice,zslice)

%%%% Multiple z-plane view
figure('units','normalized','outerposition',[0 0 1 1])
for t=1:2:Nt
    % slice(X,Y,Z,V(:,:,:,t),xslice,yslice,zslice)
  
   [az,el] = view;
    
    h=slice(Xq,Yq,Zq,interp3(X,Y,Z,V(:,:,:,t),Xq,Yq,Zq),xslice,yslice,zslice,'linear');
    % set(h,'edgecolor','k')
    axis tight
    view(az,el);
    if(t==1)
        view(-38.5,16)
    else
        view(az,el)
    end
    %     view(-38.5,16)
    xlim([min(x),max(x)])
    ylim([min(y),max(y)])
    zlim([min(z),max(z)])
    shading interp
    lighting gouraud
    material dull
    colorbar
    drawnow
    % pause(.01)
end

return


%%%% Multiple Contours view
for t=1:Nt
    % slice(X,Y,Z,V(:,:,:,t),xslice,yslice,zslice)
    % h=slice(Xq,Yq,Zq,interp3(X,Y,Z,V(:,:,:,t),Xq,Yq,Zq),xslice,yslice,zslice,'linear');
    % set(h,'edgecolor','none')
    h=contourslice(Xq,Yq,Zq,interp3(X,Y,Z,V(:,:,:,t),Xq,Yq,Zq),xslice,yslice,zslice,lvls);
    axis tight
    view(-38.5,16)
    xlim([min(x),max(x)])
    ylim([min(y),max(y)])
    zlim([min(z),max(z)])
    shading interp
    lighting gouraud
    material dull
    colorbar
    drawnow
    % pause(.01)
    cla
end

%%% Rotated plane view
hslice = surf(linspace(min(x),max(x)*sqrt(2)/2,100),...
    linspace(min(y),max(y)*sqrt(2)/2,100),...
    zeros(100));
rotate(hslice,[-1,0,0],-45)
xd = get(hslice,'XData');
yd = get(hslice,'YData');
zd = get(hslice,'ZData');
delete(hslice)




for t=1:Nt
    % slice(X,Y,Z,V(:,:,:,t),xslice,yslice,zslice)
    colormap(jet)
    h = slice(X,Y,Z,V(:,:,:,t),xd,yd,zd);
    h.FaceColor = 'interp';
    h.EdgeColor = 'none';
    h.DiffuseStrength = 0.8;
    colorbar
    hold on
    hx = slice(X,Y,Z,V(:,:,:,t),max(x),[],[]);
    hx.FaceColor = 'interp';
    hx.EdgeColor = 'none';
    
    hy = slice(X,Y,Z,V(:,:,:,t),[],max(y),[]);
    hy.FaceColor = 'interp';
    hy.EdgeColor = 'none';
    
    hz = slice(X,Y,Z,V(:,:,:,t),[],[],min(z));
    hz.FaceColor = 'interp';
    hz.EdgeColor = 'none';
    if(t==1)
        % daspect([1,1,1])
        axis tight
        view(-38.5,16)
        xlim([min(x),max(x)])
        ylim([min(y),max(y)])
        zlim([min(z),max(z)])
        camproj perspective
        lightangle(-45,45)
        colormap (jet(24))
    end
    drawnow
    % pause(.1)
end