process fastqc {
    label 'normal'
    cpus 2
    memory '12 GB'
    container 'biocontainers/fastqc:v0.11.9_cv8'
    
    input:
        path (fastq1)
        path (fastq2)

    output:
        publishDir "${params.outdir}/fastqc", mode: 'copy'
        path "*.html", emit: fastqc

    script:
        """
        fastqc ${fastq1}
        fastqc ${fastq2}
        """
}

process dragen {
    label 'dragen'
    cpus 12
    memory '200 GB'
    container ext.image ?: 'etycksen/dragen4:4.2.4'

    input:
        path (hash)
        path (fastq1)
        path (fastq2)

    output:
        publishDir "${params.outdir}/dragen", mode: 'copy'
        path "results/*", emit: results

    script:
        def args_license = task.ext.args_license ?: ''
        """
        mkdir -p results

        /opt/edico/bin/dragen \\
        --output-directory results \\
        --fastq-file1 ${fastq1} \\
        --fastq-file2 ${fastq2} \\
        --output-file-prefix NA24385 \\
        --ref-dir ${hash} \\
        --enable-map-align true \\
        --vc-sample-name NA24385 \\
        --RGID 1 \\
        --RGSM NA24385  \\
        --output-format BAM \\
        --enable-map-align-output true \\
        --enable-variant-caller true \\
        ${args_license}
        """
}

workflow {
    fastqc(params.fastq1, params.fastq2)
    dragen (params.hash, params.fastq1, params.fastq2)
}


