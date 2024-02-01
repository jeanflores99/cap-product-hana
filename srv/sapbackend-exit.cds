using {sapbackend as external} from './external/sapbackend.csn';

define service SapBackendExit {
    @cds.persistence: {
        table,
        skip: false
    }
    @cds.autoexpose
    entity Incidents as projection on external.IncidentsSet;

}

@protocol: 'rest'
define service RestService {
    entity Incidents as projection on SapBackendExit.Incidents
}

