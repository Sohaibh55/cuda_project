def remove_outliers(dataset, groupby, var_to_compute):

    grouped = dataset.groupby(by=groupby)[var_to_compute]

    q1 = grouped.transform('quantile', 0.25)
    q3 = grouped.transform('quantile', 0.75)

    iqr = q3 - q1

    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr

    mask = (
        (dataset[var_to_compute] >= lower_bound) &
        (dataset[var_to_compute] <= upper_bound)
    )
    
    return dataset[mask]



def stats(dataset, groupby, var_to_compute, statistics=None):

    if statistics is None:
        statistics = ['count', 'min', 'max', 'median', 'mean', 'std']

    statis_data = dataset.groupby(groupby)[var_to_compute].agg(statistics)

    statis_data['cv'] = statis_data['std'] / statis_data['mean']
    statis_data['cv_%'] = statis_data['std'] / statis_data['mean'] * 100

    return statis_data

def speedup(cpu_time, gpu_time):
    return cpu_time / gpu_time

def benchmark_summary():
    pass
def compare_cpu_gpu():
    pass


def plot_cpu_gpu(cpu_data, gpu_data):
    pass

def benchmark_report(cpu_data, gpu_data):
    pass







