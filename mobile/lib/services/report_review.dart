String buildReviewSummary(Map<String, dynamic> report) {
  final referenceNumber = (report['referenceNumber'] ?? 'N/A').toString();
  final issueType = (report['issueType'] ?? 'Unknown issue').toString();
  final location = (report['location'] ?? 'Unknown location').toString();
  final status = (report['status'] ?? 'SUBMITTED').toString().toUpperCase();
  final priority = (report['priority'] ?? 'MEDIUM').toString().toUpperCase();

  return [
    'Reference: $referenceNumber',
    'Issue: $issueType',
    'Location: $location',
    'Status: $status',
    'Priority: $priority',
  ].join('\n');
}
