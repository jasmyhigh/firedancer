#ifndef HEADER_fd_src_app_fdctl_run_h
#define HEADER_fd_src_app_fdctl_run_h

#include "../fdctl.h"

FD_PROTOTYPES_BEGIN

void *
create_clone_stack( void );

void
agave_boot( config_t * config );

int
agave_main( void * args );

int
clone_firedancer( config_t * const config,
                  int              close_fd,
                  int *            out_pipe );

void
fdctl_check_configure( config_t * const config );

void
initialize_workspaces( config_t * const config );

void
initialize_stacks( config_t * const config );

void
run_firedancer_init( config_t * const config,
                     int              init_workspaces );

void
run_firedancer( config_t * const config,
                int              parent_pipefd,
                int              init_workspaces );

FD_PROTOTYPES_END

#endif /* HEADER_fd_src_app_fdctl_run_h */
