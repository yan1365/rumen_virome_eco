import os
import pandas as pd
import itertools

os.chdir("/fs/ess/PAS0439/MING/virome_ecology/results/R_project/")

metadata = pd.read_csv("metadata_ecology.csv")
metadata = metadata.query('species in ["Ovis_aries", "Capra_hircus", "Bos_taurus"]')

project_filtered = set(metadata.groupby(['project', 'species']).id.count().reset_index().query('id >= 12').project)
metadata = metadata.query('project in @project_filtered')

metadata.loc[metadata.query('project == "PRJNA214227"').query('species == "Bos_taurus"')["project"].index, "project"] = "PRJNA214227_Bos_taurus"
metadata.loc[metadata.query('project == "PRJNA214227"').query('species == "Ovis_aries"')["project"].index, "project"] = "PRJNA214227_Ovis_aries"
metadata.loc[metadata.query('project == "PRJEB23561"').query('beef_or_dairy == "beef"')["project"].index, "project"] = "PRJEB23561_Beef"
metadata.loc[metadata.query('project == "PRJEB23561"').query('beef_or_dairy == "dairy"')["project"].index, "project"] = "PRJEB23561_Dairy"

metadata = metadata[["id", "project"]]

# clusters based on hierachical clustering results
cluster1 = "PRJEB31266"
cluster2 = "PRJEB21624"
cluster3 = ['PRJNA639405', 'PRJEB33080', 'PRJNA202380']
cluster4 = ['PRJEB23561_Dairy', 'PRJEB8939', 'PRJNA214227_Ovis_aries', 'PRJNA492173', 
 'PRJNA552122', 'PRJNA622657', 'PRJNA627251', 'PRJNA627299', 'PRJNA630534']
cluster5 = ['PRJEB34231', 'PRJNA214227_Bos_taurus', 'PRJNA448333', 'PRJNA522848', 
            'PRJNA526070', 'PRJNA597489 ', 'PRJNA631602', 'PRJEB23561_Beef']

cluster_df = {}
cluster_df["cluster1"] = cluster1
cluster_df["cluster2"] = cluster2
cluster_df["cluster3"] = cluster3
cluster_df["cluster4"] = cluster4
cluster_df["cluster5"] = cluster5

    

table = pd.read_csv("virome_presence_matrix.csv")

def co_occurence(Set):
    id1 = Set[0]
    id2 = Set[1]
    
    votu_index_id1 = table[id1].reset_index().rename(columns = {id1 : "tmp"}).query('tmp > 0').index
    votu_index_id2 = table[id2].reset_index().rename(columns = {id2 : "tmp"}).query('tmp > 0').index
    
    votu_id1 = set(table.loc[votu_index_id1, "Contig"])
    votu_id2 = set(table.loc[votu_index_id2, "Contig"])
    
    n_co_occurance = len(votu_id1 & votu_id2)
    
    return n_co_occurance

comparison_dic = {}
i = 0
for f in [cluster1, cluster2, cluster3, cluster4, cluster5]:
    ids = list(metadata.query('project in @f').id)
    tmp = []
    i += 1
    

    for comb in itertools.combinations(ids, 2):
        tmp.append(comb)
    
    comparison_dic[f"cluster{i}_comparison"] = tmp


for f in list(comparison_dic.keys()):
    co_occurrence_dic = {}
    co_occurrence_df_pre = {}
    cluster = cluster_df[f.split("_comparison")[0]]
    sample_to_compare = list(metadata.query('project in @cluster')['id'])
       
    print(f)
    tmp = {}
    for i in comparison_dic[f]:
        tmp[frozenset(i)] = co_occurence(i)
        
    co_occurrence_dic[f] = tmp
    
    for s in sample_to_compare:
        sample_comparison = {}
        to_compare = [_ for _ in sample_to_compare if _ != s]
        for m in to_compare:

            sample_comparison[m] = tmp[frozenset([m, s])]
            sample_comparison[s] = sum(table.loc[:,s])
        co_occurrence_df_pre[s] = sample_comparison
        df = pd.DataFrame(co_occurrence_df_pre)
        df.to_csv(f"/fs/ess/PAS0439/MING/virome_ecology/results/R_project/{f}_for_network.csv")