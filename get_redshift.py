import os
import numpy as np
from astropy.io import fits
from astropy.table import Table
from astropy import units as u
from astropy.coordinates import SkyCoord


def create_sweepfile_dict(listdir = ['/global/project/projectdirs/cosmo/data/legacysurvey/dr9/north/sweep/9.0', '/global/project/projectdirs/cosmo/data/legacysurvey/dr9/south/sweep/9.0']):
    '''Creates dictionary of sweep files containing path, min 
    and max ra and dec for the block.
    
    Parameters
    ----------
    listdir : list of str, optional
        list of directory paths to search for sweep files.
        defaults to dr9 north and south sweeps
    
    Returns
    -------
    files : dict
        A dictionary w/ filename for keys.
        Every key maps to another dictionary containing 
        'min_ra' 'max_ra' 'min_dec' 'max_dec' and 'path'
    '''
    files = {}
    for dir in listdir:
        for dirname, __, filenames in os.walk(dir):

            for filename in filenames:
                block = filename[6:-5]
                
                if block[6].isdigit():

                    min_ra = int(block[:3])
                    min_dec = int(block[4:7])
                    if block[3] == 'm':
                        min_dec = int('-'+str(min_dec))
                        
                    max_ra = int(block[8:11])
                    max_dec = int(block[12:])
                    if block[-4] == 'm':
                        max_dec = int('-'+str(max_dec))
                        
                    files[filename]={'min_ra':min_ra, 'max_ra':max_ra, 'min_dec': min_dec, 'max_dec':max_dec, 'path':os.path.join(dirname, filename)}
    return files



def find_host_galaxy_file(files,ra, dec):
    '''Matches transient to corresponding host sweep file by 
    finding which block it is in.
    
    Parameters
    ----------
    files : dict
        A dictionary w/ filename for keys.
        Every key maps to another dictionary containing 
        'min_ra' 'max_ra' 'min_dec' 'max_dec' and 'path'
    ra : float
        pseudo-host ra for observed transient
    dec : float
        pseudo-host dec for observed transient
    
    Returns
    -------
    path : str or nan
        full path of the matching sweep file.
        Returns nan if no match is found.
    '''
    for i in files.keys():
         if ra>=files[i]['min_ra'] and ra<=files[i]['max_ra'] and dec>=files[i]['min_dec'] and dec<=files[i]['max_dec']:
            return files[i]['path']
         else: continue

    return float(np.NaN)

def find_ID_RA_DEC_lists_in_brick(brick_path):
    '''Finds lists of OBJID, RA, DEC
    
    Parameters
    ----------
    sweepfile_path : str
        A sweep file path to extract objects from.
    
    Returns
    -------
    OBJID_RA_DEC : list of 3 lists
        List of 3 lists corresponding to objid, ra, dec respectiveliy
        of all objects in the brick sweep file.
    '''
    hdus = fits.open(brick_path)
    data = Table(hdus[1].data)
    return [list(data['OBJID']), list(data['RA']), list(data['DEC'])]
    
def find_redshift(obj_list, path, ra, dec):

    '''Finds Spectroscopic and Photometric redshift and Standard Deviation
       NOTE: - Spectroscopic Redshift will be -99.0 if it does not exist
             - I the associated photo-z file does not exist, returns a tuple
               of type nan
       
    Parameters
    ----------
    onj_list : list of 3 lists
        List of 3 lists corresponding to objid, ra, dec respectiveliy
        of all objects in the brick sweep file. 
    sweepfile_path : str
        A sweep file path associated with the matching brick.
    ra : float
        pseudo-host ra for observed transient
    dec : float
        pseudo-host dec for observed transient
    
    Returns
    -------
     z_spec, z_photo_mean, z_photo_err: tuple
        A tuple containing spectroscopic redshift, mean of photometric redshift,
        and photometric redshift standard deviation respectively of the matching
        object within the sweep file.
    '''
    c = SkyCoord(ra*u.degree, dec*u.degree)
    catalog = SkyCoord(obj_list[1]*u.degree, obj_list[2]*u.degree)
    idx, d2d, d3d = c.match_to_catalog_3d(catalog)
    obj_id = obj_list[0][idx]
    
    sweep_pz = path.replace('9.0', '9.0-photo-z').replace('.fits', '-pz.fits')

    if os.path.exists(sweep_pz):
        hdus = fits.open(sweep_pz)
        redshift_data = Table(hdus[1].data)
        try:
            assert redshift_data['OBJID'][idx] == obj_id, 'object ID does not match'
            z_spec, z_photo_mean, z_photo_err = (redshift_data['Z_SPEC'][idx],redshift_data['Z_PHOT_MEAN'][idx], redshift_data['Z_PHOT_STD'][idx])
            return (z_spec, z_photo_mean, z_photo_err)
        except AssertionError as msg:
            print(msg)            
    else:
        print(os.path.exists(sweep_pz))
    return (np.NaN, np.NaN, np.NaN)


def do_all(ra, dec):
    files = create_sweepfile_dict()
    path = find_host_galaxy_file(files, ra, dec)
    obj_lists = find_ID_RA_DEC_lists_in_brick(path)
    z_spec, z_photo_mean, z_photo_err = find_redshift(obj_lists, path, ra, dec)
    return {'z_spec': z_spec, 'mean': z_photo_mean,'err': z_photo_err}
