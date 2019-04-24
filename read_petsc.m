% [FileName,PathName,~] = uigetfile('../*.txt');
function [c,phi,al]=read_petsc()
[FileName,PathName,~] = uigetfile('../../C_Progs/2d_CSD/cmake-build-debug/*.txt');

f=fopen(strcat(PathName,FileName));
% f=fopen('/Users/Austin/Documents/MATLAB/2d_csd/test.txt');
header=textscan(f,'%d,%d,%d,%d,%d',1);
fclose(f);
[Nx,Ny,Nt,Nc,Ni]=header{1:5};
A=dlmread(strcat(PathName,FileName),',',1,0);

c=zeros(Nx,Ny,Nc,Ni,Nt);
phi=zeros(Nx,Ny,Nc,Nt);
al=zeros(Nx,Ny,Nc-1,Nt);

if(Nc==0 && Ni==0)
   one_var = true;
   Ni=1;
   Nc=1;
else
    one_var= false; 
end


if(one_var)
    V=zeros(Nx,Ny,Nt);
ind=1;
for t=1:Nt
            V(:,:,t)=reshape(A(ind,:),Nx,Ny);
            ind=ind+1;
end
         c=V;phi=0;al=0;
else
c=zeros(Nx,Ny,Nc,Ni,Nt);
phi=zeros(Nx,Ny,Nc,Nt);
al=zeros(Nx,Ny,Nc-1,Nt);
    ind=1;
for t=1:Nt
    for j=1:Ni
        for i=1:Nc
            c(:,:,i,j,t)=reshape(A(ind,:),Nx,Ny);
            ind=ind+1;
        end
    end
    
    for j=1:Nc
        phi(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
        ind=ind+1;
    end
    for j=1:Nc-1
        al(:,:,j,t)=reshape(A(ind,:),Nx,Ny);
        ind=ind+1;
    end
end
end

% h = figure;
% axis tight manual % this ensures that getframe() returns a consistent size
% filename = 'boundary_fast.gif';
% close all
% 
% v=linspace(min(min(min(c(:,:,1,2,:)))),max(max(max(c(:,:,1,2,:)))),50);
% for i=2:Nt
%     contourf(c(:,:,1,2,i),v,'linestyle','none')
%     caxis([min(v),max(v)])
%     colorbar
%     drawnow 
%       % Capture the plot as an image 
%       frame = getframe(h); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
%       % Write to the GIF File 
%       if i == 2 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
% %     pause(.001)
% end
% v=linspace(min(min(min(al(:,:,1,:)))),max(max(max(al(:,:,1,:)))),10);
% for i=2:Nt
%     contourf(al(:,:,1,i),v)
%     caxis([min(v),max(v)])
%     colorbar
%     pause(.001)
% end
% v=linspace(min(min(min(phi(:,:,1,:)))),max(max(max(phi(:,:,1,:)))),10);
% for i=2:Nt
%     contourf(phi(:,:,1,i),v)
%     caxis([min(v),max(v)])
%     colorbar
%     pause(.001)
% end
end