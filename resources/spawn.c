#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#include "mpi.h"

int main(int argc, char* argv[]) {
        int my_rank, size;

        MPI_Init(&argc, &argv);
        MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Status status;

        MPI_Comm intercomm;
        MPI_Comm parentcomm;

        int errcodes[1];
        char hostname[100];

        //char *jobName;
        //jobName = getenv("PBS_JOBID");

        gethostname(hostname, sizeof hostname);

        printf( "worldsize:%d, rank:%d mapped to %s\n", size, my_rank, hostname ); fflush(stdout);
        MPI_Comm_get_parent( &parentcomm );

        printf("parent returned \n"); fflush(stdout);
        if (parentcomm == MPI_COMM_NULL)
        {
                MPI_Info info;
                MPI_Info_create( &info);
                MPI_Info_set( info, "add-host", "olnode2");
                MPI_Info_set( info, "dac_maxandmin", "3,2");
                MPI_Info_set( info, "dac_maxorexit", "FALSE");

                MPI_Comm_spawn( "/vagrant/resources/spawn", MPI_ARGV_NULL, 12, info, 0, MPI_COMM_WORLD, &intercomm, errcodes );

        } else{
               printf(" i am the one who has been spawned \n"); fflush(stdout);
        }
        printf("done ......\n"); fflush(stdout);

        MPI_Finalize();
        return 0;
}
