# Register Redhat system

Simple wrapper for the Redhat `subscription-manager` command to automatically unregister the key in a post step. 

Example usage:

```yaml
      - uses: r-hub/actions/register-redhat@v1
        env:
          REDHAT_ORG: ${{ secrets.REDHAT_ORG }}
          REDHAT_KEY: ${{ secrets.REDHAT_KEY }}
```
