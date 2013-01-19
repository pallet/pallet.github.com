### Dependency Information

{% assign repos = {sonatype: "https://oss.sonatype.org/content/repositories/releases/", clojars: https://clojars.org/repo} %}


<pre>
:dependencies [[{{page.groupid}}/{{page.artifactid}} "{{page.version}}"]]
{% if "sonatype" == page.mvnrepo %}:repositories 
  {"sonatype" 
   {:url "https://oss.sonatype.org/content/repositories/releases/"}}
{% endif %}</pre>

### Releases

<table>
{% for v in page.versions %}
  <tr>
    <th>{{ v['pallet'] }}</th>
    <td>{{ v['version'] }}</td>
    <td><a href='https://github.com/{{page.repo}}/blob/{{page.artifactid}}-{{v['version']}}/ReleaseNotes.md'>Release Notes</a></td>
    <td><a href='https://github.com/{{page.repo}}/blob/{{page.artifactid}}-{{v['version']}}/{{page.path}}'>Source</a></td>
  </tr> 
{% endfor %}
</table>
