### Dependency Information

{% assign repos = {sonatype: "https://oss.sonatype.org/content/repositories/releases/", clojars: https://clojars.org/repo} %}


<pre>
:dependencies [[{{page.groupid}}/{{page.artifactid}} "{{page.version}}"]]
{% if "sonatype" == page.mvnrepo %}:repositories 
  {"sonatype" 
   {:url "https://oss.sonatype.org/content/repositories/releases/"}}
{% endif %}</pre>

For versions 0.7.x and earlier

<pre>
:repositories
  {"sonatype"
   {:url "https://oss.sonatype.org/content/repositories/releases/"}}
</pre>

### Releases

<table>
<thead>
  <tr><th>Pallet</th><th>Latest Crate Version</th></tr>
</thead>
<tbody>
{% for v in page.versions %}
  <tr>
    <th>{{ v['pallet'] }}</th>
    <td>{{ v['version'] }}</td>
    <td><a href='https://github.com/{{page.repo}}/blob/{{page.artifactid}}-{{v['version']}}/ReleaseNotes.md'>Release Notes</a></td>
    <td><a href='https://github.com/{{page.repo}}/blob/{{page.artifactid}}-{{v['version']}}/{{page.path}}'>Source</a></td>
  </tr> 
{% endfor %}
</tbody>
</table>
