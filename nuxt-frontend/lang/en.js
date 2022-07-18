export default {
  app: {
    titleAbbreviation: 'GRIP'
  },
  common: {
    unavailable: 'N/A',
    logout: 'Logout',
    login: 'Login',
    cancel: 'Cancel',
    save: 'Save',
    noResults: 'No results found.'
  },
  components: {
    accountDropdown: {
      navigationLogoutLink: {
        text: 'Logout'
      },
      navigation: [],
      triggerLabel: 'User menu'
    },
    basicSort: {
      label: 'Sort'
    },
    gefPortfolio: {
      filters: {
        labels: {
          focalAreas: 'Core Areas',
          georegions: 'Region or Country',
          users: 'Task Manager/Program Assistant',
          dateRange: {
            heading: 'Select a date range',
            from: 'From',
            to: 'to'
          }
        }
      },
      sidepanel: {
        projectsLocatedInCountry: 'GEF Projects located in %{georegion}',
        notice: 'Note: Some projects are located in more than one area, there will be more pins listed than the total number of overall GEF projects.',
        indicators: {
          heading: 'Progress towards indicators'
        }
      },
      chart: {
        labels: {
          yleft: 'No Projects with PIR',
          yright: 'Indicator Value',
          annotation: 'Expected Value'
        }
      }
    },
    layout: {
      navigation: {
        topbar: {
          tabs: [
            {
              text: 'UNEP GEF Portfolio',
              to: '/gef-portfolio'
            },
            {
              text: 'My Projects',
              to: '/gef-projects'
            }
          ]
        }
      }
    },
    project: {
      card: {
        importError: {
          text: 'Content Error',
          modal: {
            content: {
              id: 'ID: %{id}',
              errorsDetected: '%{errorCount} errors detected',
              correctionMessage: 'Please correct the data in the Sharepoint spreadsheets indicated to allow complete syncing of this project',
              dataSource: {
                errors: {
                  rowNumber: 'Row Number - %{rowNumber}'
                }
              }
            },
            dataSources: {
              dataSource: 'Data Source: %{dataSource}'
            }
          }
        }
      },
      shapefileUpload: {
        id: 'ID: %{id}',
        title: 'Upload Project Shape File',
        pill: 'Upload Completed',
        dropzone: {
          button: 'Browse Files',
          label: 'Drag and drop shape files here',
          separator: 'or',
          helperText: 'Please include these files: shp, shx, dbf and prj'
        }
      },
      syncHeader: {
        button: 'Sync',
        lastUpdateLabel: 'Last Update:'
      }
    },
    tile: {
      linkText: 'Explore'
    }
  },
  constants: {
    gefProjectValidStatuses: {
      completed: 'Completed',
      notCompleted: 'Not Completed',
      na: 'N/A',
      ongoing: 'Ongoing',
      underImplementation: 'Under Implementation'
    }
  },
  layout: {
    footer: {
      copyright: '&copy; %{currentYear} WCMC',
      links: [
        {
          text: 'Terms and Conditions',
          href: '/terms-and-conditions'
        },
        {
          text: 'Privacy policy',
          href: '/privacy-policy'
        }
      ]
    }
  },
  pages: {
    home: {
      hero: {
        title: 'UNEP-GEF Geospatial Results & Intelligence Platform (GRIP)',
        subtitle: "GRIP is a tool to synthesize, map and visualize UNEP's GEF Biodiversity and Land Degradation projects and facilitate reporting against targeted results."
      },
      banner: {
        text: 'Biodiversity loss and land degradation are among the most urgent challenges facing the world today. GRIP aims to improve our collective ability to tackle these challenges by enabling users to investigate emerging biodiversity and land use trends across space and time and within multiple temporal and geographical scales.',
        title: 'What can you do with GRIP?',
        alt: 'World map'
      }
    },

    gefProjects: {
      buttons: {
        allProjects: 'All projects',
        archivedProjects: 'Archived projects'
      },
      noResults: {
        text: 'You currently have no projects'
      },
      sort: {
        oldest: 'Oldest',
        newest: 'Newest'
      }
    }
  },
  project: {
    card: {
      id: 'ID: %{id}',
      labels: {
        title: 'Project Title',
        georegions: 'Country'
      },
      buttons: {
        moreInfo: 'More info',
        exploreMap: 'Explore map',
        archive: 'Archive project',
        restore: 'Restore project',
        add: 'Add missing shape file',
        edit: 'Edit shape file'
      },
      moreInfoModal: {
        headings: {
          id: 'ID: %{id}',
          location: 'Location',
          implementingAgencies: 'Executing Agency',
          projectGrant: 'Project Grant',
          focalAreas: 'Focal Areas',
          projectTimeline: 'Project Timeline',
          midTermEvaluationStatus: 'Project Midterm Review',
          terminalEvaluationStatus: 'Terminal Evaluation',
          projectFocals: 'Project Focals',
          taskManager: 'Task Manager',
          paFocalPoint: 'Programme Assistant',
          fmo: 'Fund Management Officer',
          faFocalPoint: 'Finance Assistant'
        },
        links: {
          dashboard: 'Dashboard',
          gefWebsite: 'GEF Website'
        },
        buttons: {
          archiveProject: 'Archive project'
        }
      }
    }
  }
}
