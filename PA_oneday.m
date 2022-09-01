% Process Analysis of O3(unit:ppbV) from Simulation on several levels
% Note that this one-day script uses for general days except the begin or the end of a month and a year
% Date: 2022-08-30
% Edited by Evan
% ==================================
clc
clear
close all

Program_Starts_at=datetime('now')

% ==================================
% Read Gridfile
% ==================================
DataPath='F:/Data/caseGZ_2207/';
GridName='CN3GD_152X110';
close

% ==================================
% Read CMAQ-PA Output
% ==================================

% set date; ! Be careful when it comes to the end of a month or a year !
date=728; % Note here to modify
ncFile1=string(DataPath)+'PA/CCTM_PA_1_v533_intel_'+string(GridName)+'_20220'+num2str(date-1)+'.nc';
ncFile2=string(DataPath)+'PA/CCTM_PA_1_v533_intel_'+string(GridName)+'_20220'+num2str(date)+'.nc';

% read Var=O3
HADV = cat(4,ncread(ncFile1,'HADV_O3')*1000,ncread(ncFile2,'HADV_O3')*1000); % (lon,lat,layer=38,tstep=48)
ZADV = cat(4,ncread(ncFile1,'ZADV_O3')*1000,ncread(ncFile2,'ZADV_O3')*1000);
HDIF = cat(4,ncread(ncFile1,'HDIF_O3')*1000,ncread(ncFile2,'HDIF_O3')*1000);
VDIF = cat(4,ncread(ncFile1,'VDIF_O3')*1000,ncread(ncFile2,'VDIF_O3')*1000);
DDEP = cat(4,ncread(ncFile1,'DDEP_O3')*1000,ncread(ncFile2,'DDEP_O3')*1000);
CHEM = cat(4,ncread(ncFile1,'CHEM_O3')*1000,ncread(ncFile2,'CHEM_O3')*1000);

% ==================================
% Data Processing
% ==================================

% set location at GZ;
slon=72;
elon=74;
slat=57;
elat=60;


% calculate averages in lon & lat
HADV = squeeze(nanmean(HADV(slon:elon,:,:,:),1));
HADV = squeeze(nanmean(HADV(slat:elat,:,:),1)); % (layer=38,tstep=48)

ZADV = squeeze(nanmean(ZADV(slon:elon,:,:,:),1));
ZADV = squeeze(nanmean(ZADV(slat:elat,:,:),1));

HDIF = squeeze(nanmean(HDIF(slon:elon,:,:,:),1));
HDIF = squeeze(nanmean(HDIF(slat:elat,:,:),1));

VDIF = squeeze(nanmean(VDIF(slon:elon,:,:,:),1));
VDIF = squeeze(nanmean(VDIF(slat:elat,:,:),1));

DDEP = squeeze(nanmean(DDEP(slon:elon,:,:,:),1));
DDEP = squeeze(nanmean(DDEP(slat:elat,:,:),1));

CHEM = squeeze(nanmean(CHEM(slon:elon,:,:,:),1));
CHEM = squeeze(nanmean(CHEM(slat:elat,:,:),1));

% convert layer to Pheight(hPa)
nLayer=28;
% eta_levels =...
% [1.0000,0.9979,0.9956,0.9931,0.9904,0.9875,...
% 0.9844,0.9807,0.9763,0.9711,0.9649,0.9575,...
% 0.9488,0.9385,0.9263,0.9120,0.8951,0.8753,...
% 0.8521,0.8251,0.7937,0.7597,0.7229,0.6883,...
% 0.6410,0.5960,0.5484,0.4985,0.4467,0.3934,...
% 0.3393,0.2850,0.2316,0.1801,0.1324,0.0903,...
% 0.0542,0.0241,0.0000];
% for i=1:nLayer
%     Pheight(i) = (1000-50)*eta_levels(i)+50;
% end

% select tstep
tstep=[17:40]; 
hour=[0:23];
%%
% ==================================
% Plot
% ==================================
for i=1:size(tstep,2)
    figure('visible','off');
    % y=[squeeze(HADV(1:nLayer,tstep(i))),squeeze(ZADV(1:nLayer,tstep(i))),...
    % squeeze(HDIF(1:nLayer,tstep(i))),squeeze(VDIF(1:nLayer,tstep(i))),...
    % squeeze(DDEP(1:nLayer,tstep(i))),squeeze(CLDS(1:nLayer,tstep(i))),...
    % squeeze(AERO(1:nLayer,tstep(i))),squeeze(CHEM(1:nLayer,tstep(i))),...
    % squeeze(EMIS(1:nLayer,tstep(i)))];
    y=[squeeze(HADV(1:nLayer,tstep(i))),squeeze(ZADV(1:nLayer,tstep(i))),...
    squeeze(HDIF(1:nLayer,tstep(i))),squeeze(VDIF(1:nLayer,tstep(i))),...
    squeeze(DDEP(1:nLayer,tstep(i))),squeeze(CHEM(1:nLayer,tstep(i)))];
    % barh(Pheight,y,'stacked');
    % set(gca,'YDir','reverse');
    h=barh(y,0.98,'stacked');
    set(h,'edgecolor','none');

    axis([-100,100,0,30]);
    set(gca,'XTick',[-100:20:100],'fontsize',12);
    set(gca,'YTick',[1:3:28],'fontsize',12);
    set(gca,'YTicklabel',{'1000','993','985','972','950','916','850','770','660','520'});
    xlabel('Concentration of O3(ppbv)','fontsize',13);
    ylabel('Pressure(hPa)','fontsize',13);
    title(['GZ\_0',num2str(date),' ',num2str(hour(i)),':00'],'fontsize',18);

    % l=legend('HADV','ZADV','HDIF','VDIF','DDEP','CHEM','Location','NorthWest','fontsize',10);
    l=legend('水平平流','垂直平流','水平扩散','垂直扩散','干沉降','气相化学过程','Location','NorthWest','fontsize',10);
    % l=legend('HADV','ZADV','HDIF','VDIF','DDEP','CLDS','AERO','Location','SouthOutside','orientation','horizontal','fontsize',6);
    set(l,'Box','off');
    Now_printing_figure_on=['2022-0',num2str(date),'-',num2str(hour(i))]
    path = ['F:/Data/caseGZ_2207/Figure/PA_ver/',num2str(date),'_',num2str(hour(i))]; % Note here to modify
    print(gcf,'-dpng','-r600',path)
end
Program_Ends_at=datetime('now')
