#!/usr/bin/env python3
import pandas as pd
from collections import defaultdict
import sys    
# from https://instrain.readthedocs.io/en/master/user_manual.html

def parse_dbcan(floc):
    """
    v1.0 - 1/6/2023

    Parse dbcan2 results

    Returns:
        Cdb: DataFrame with dbCAN2 results
    """

    h = ['Family_HMM', 'HMM_length', 'gene', 'Query_length', 'E-value', 'HMM_start', 'HMM_end', 'Query_start', 'Query_end', 'Coverage']
    Zdb = pd.read_csv(floc, sep='\t', names=h)

    # Parse names
    def get_type(f):
        for start in ['PL', 'AA', 'GH', 'CBM', 'GT', 'CE']:
            if f.startswith(start):
                return start
        if f in ['dockerin', 'SLH', 'cohesin']:
            return 'cellulosome'
        print(f)
        assert False

    def get_family(f):
        for start in ['PL', 'AA', 'GH', 'CBM', 'GT', 'CE']:
            if f.startswith(start):
                if f == 'CBM35inCE17':
                    return 35
                try:
                    return int(f.replace(start, '').split('_')[0])
                except:
                    print(f)
                    assert False
        if f in ['dockerin', 'SLH', 'cohesin']:
            return f
        print(f)
        assert False

    def get_subfamily(f):
        if f.startswith('GT2_'):
            if f == 'GT2_Glycos_transf_2':
                return 0
            else:
                return f.split('_')[-1]
        if '_' in f:
            try:
                return int(f.split('_')[1])
            except:
                print(f)
                assert False
        else:
            return 0

    t2n = {'GH':'glycoside hydrolases',
          'PL':'polysaccharide lyases',
          'GT':'glycosyltransferases',
          'CBM':'non-catalytic carbohydrate-binding modules',
          'AA':'auxiliary activities',
          'CE':'carbohydrate esterases',
          'cellulosome':'cellulosome'}

    ZIdb = Zdb[['Family_HMM']].drop_duplicates()
    ZIdb['raw_family'] = [x.split('.')[0] for x in ZIdb['Family_HMM']]
    ZIdb['class'] = [get_type(f) for f in ZIdb['raw_family']]
    ZIdb['class_name'] = ZIdb['class'].map(t2n)
    ZIdb['family'] = [get_family(f) for f in ZIdb['raw_family']]
    ZIdb['subfamily'] = [get_subfamily(f) for f in ZIdb['raw_family']]

    ZIdb['CAZyme'] = [f"{c}{f}_{s}" for c, f, s in zip(ZIdb['class'], ZIdb['family'], ZIdb['subfamily'])]

    ZSdb = pd.merge(Zdb, ZIdb[['Family_HMM', 'class', 'family',
      'subfamily', 'CAZyme']], on='Family_HMM', how='left')

    # Reorder
    ZSdb = ZSdb[[
        'gene',
        'CAZyme',
        'class',
        'family',
        'subfamily',
        'Family_HMM',
        'HMM_length',
        'Query_length',
        'E-value',
        'HMM_start',
        'HMM_end',
        'Query_start',
        'Query_end',
        'Coverage',
        ]]

    #return ZSdb
    ZSdb.to_csv("/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/07_inStrain/diet/cazy_parse_out.csv", index = None)
if __name__ == "__main__":
    
    floc = "/fs/scratch/PAS0439/Ming/virome_ecology_core_prkaryotes/results/07_inStrain/diet/repre_genomes_instrain.genes.faa_vs_dbCAN_v11.dm.ps"
    parse_dbcan(floc)